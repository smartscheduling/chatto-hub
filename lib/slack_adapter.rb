require 'rest-client'
require 'pry'

class SlackAdapter
  attr_reader :team_id
  def initialize(team_id=nil)
    @team_id = team_id || ENV['SLACK_TEAM_ID']
  end

  def channels_create(opts={})
    Slack.channels_create(opts)
  end

  def send_team_invite(email, channel_id)
    time = Time.now.to_i.to_s
    url = "https://#{ENV['SLACK_TEAM_NAME']}.slack.com/api/users.admin.invite?t=" + time
    token = ENV['SLACK_TEST_TOKEN']

    query = { token: token, team_id: team_id, email: email,
      set_active: true, _attempts: 1, channels: channel_id}.to_query

    response = RestClient::Request.execute(method: :post, url: url, payload: query)
    JSON.parse(response)["ok"] # return true/false
  end

  def send_channel_invite(channel_id, user_id)
    response = Slack.channels_invite(channel: channel_id, user: user_id)
    response["ok"] # return true/false
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
