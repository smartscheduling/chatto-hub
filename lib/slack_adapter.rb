require 'rest-client'
require 'pry'

class SlackAdapter
  class SlackTeamInviteError < StandardError; end
  DEFAULT_CHANNEL_ID="C067NNHEY"

  attr_reader :team_id
  def initialize(team_id=nil)
    @team_id = team_id || ENV['SLACK_TEAM_ID']
  end

  def channels_create(opts={})
    Slack.channels_create(opts)
  end

  def send_team_invite(email, channel_id=DEFAULT_CHANNEL_ID)
    time = Time.now.to_i.to_s
    url = "https://#{ENV['SLACK_TEAM_NAME']}.slack.com/api/users.admin.invite?t=" + time
    token = ENV['SLACK_TEST_TOKEN']

    query = { token: token, team_id: team_id, email: email,
      set_active: true, _attempts: 1, channels: channel_id}.to_query

    response = RestClient::Request.execute(method: :post, url: url, payload: query)
    response = JSON.parse(response)

    unless response["ok"] || response["error"] == "already_in_team"
      raise SlackTeamInviteError
    end
  end

  def send_channel_invite(channel_id, user_id)
    response = Slack.channels_invite(channel: channel_id, user: user_id)
    unless response["ok"] || response["error"] == "already_in_channel"
      raise SlackTeamInviteError
    end
    true
  end

  # move id to project model
  def find_channel_by_name(name)
    name = sanitize_channel_name(name)
    channels = Slack.channels_list
    channels["channels"].find { |c| c["name"] == name }
  end

  def find_channel_id_by_name(name)
    find_channel_by_name(name)["id"]
  end

  def sanitize_channel_name(name)
    name.downcase.gsub(' ', '-')
  end

  def user_on_team?(email)
    Slack.users_list["members"].any? do |user|
      user["profile"]["email"] == email
    end
  end

  def get_user_id_by_email(email)
    user = Slack.users_list["members"].find do |user|
      user["profile"]["email"] == email
    end

    user["id"]
  end
end
