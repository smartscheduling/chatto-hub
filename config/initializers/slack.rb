require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_TEST_TOKEN']
end

SlackAdapter.team_id   = ENV['SLACK_TEAM_ID']
SlackAdapter.token     = ENV['SLACK_TEST_TOKEN']
SlackAdapter.team_name = ENV['SLACK_TEAM_NAME']
