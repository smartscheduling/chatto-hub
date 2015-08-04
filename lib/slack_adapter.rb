require 'rest-client'
# Configuration in config/initializers/slack
class SlackAdapter
  class SlackTeamInviteError < StandardError; end
  DEFAULT_CHANNEL_ID="C067NNHEY"

  cattr_accessor :team_id, :token, :team_name

  def slack
    Slack
  end

  def channels_create(opts={})
    slack.channels_create(opts)
  end

  def send_team_invite(email, channel_id=DEFAULT_CHANNEL_ID)
    time = Time.now.to_i
    url = "https://#{team_name}.slack.com/api/users.admin.invite?t=#{time}"

    query = { token: token, team_id: team_id, email: email,
      set_active: true, _attempts: 1, channels: channel_id}.to_query

    response = RestClient::Request.execute(method: :post, url: url, payload: query)
    response = JSON.parse(response)
    verify_acceptable_response!(response, :team)
  end

  def send_channel_invite(channel_id, user_id)
    response = slack.channels_invite(channel: channel_id, user: user_id)
    verify_acceptable_response!(response, :channel)
    true
  end

  def channel_url(name)
    name = sanitize_channel_name(name)
    "https://#{team_name}.slack.com/messages/#{name}/"
  end

  def find_channel_by_name(name)
    name = sanitize_channel_name(name)
    channels = slack.channels_list
    channels["channels"].find { |c| c["name"] == name }
  end

  def find_channel_id_by_name(name)
    find_channel_by_name(name)["id"]
  end

  def sanitize_channel_name(name)
    name.downcase.gsub(' ', '-')
  end

  def user_on_team?(email)
    slack.users_list["members"].any? do |user|
      user["profile"]["email"] == email
    end
  end

  def get_user_id_by_email(email)
    user = slack.users_list["members"].find do |user|
      user["profile"]["email"] == email
    end

    user["id"]
  end

  private

  def verify_acceptable_response!(response, type)
    unless response["ok"] || response["error"] == "already_in_#{type}"
      raise SlackTeamInviteError
    end
  end
end
