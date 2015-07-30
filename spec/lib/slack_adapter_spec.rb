require 'rails_helper'

SlackAdapter.team_id = "12345"
SlackAdapter.token = "cool-token"
SlackAdapter.team_name = "test-team"

describe SlackAdapter do
  subject { SlackAdapter.new }

  describe "#channels_create" do
    it "is a thin wrapper around Slack Gem's method" do
      slack_double = double(channels_create: true)
      stub_slack!(slack_double)
      expect(slack_double).to receive(:channels_create)
      subject.channels_create
    end
  end

  describe "#send_team_invite" do
    before do
      allow(Time).to receive(:now).and_return(42)
    end

    it "executes a post with the right queries" do
      email = "some_email"
      payload = "_attempts=1&channels=C067NNHEY&email=#{email}&set_active=true&team_id=12345&token=cool-token"
      proper_args = { method: :post, url: "https://test-team.slack.com/api/users.admin.invite?t=42", payload: payload }
      expect(RestClient::Request).to receive(:execute).with(proper_args).and_return({ok: true}.to_json)
      subject.send_team_invite(email)
    end

    it "returns proper error if applicable" do
      allow(RestClient::Request).to receive(:execute).and_return("{\"error\":\"already_in_team\"}")
      expect{subject.send_team_invite("email")}.to raise_error(SlackAdapter::SlackTeamInviteError)
    end
  end

  describe "#send_channel_invite" do
    it "is a thin wrapper around Slack Gem's method" do
      slack_double = double(channels_invite: { "ok" => true })
      stub_slack!(slack_double)
      expect(slack_double).to receive(:channels_invite)
      subject.send_channel_invite('channel_id', 'user_id')
    end

    it "returns true if successful" do
      slack_double = double(channels_invite: { "ok" => true })
      stub_slack!(slack_double)
      expect(subject.send_channel_invite('channel_id', 'user_id')).to eq true
    end

    it "raises an error if user is already in channel" do
      slack_double = double(channels_invite: { "ok" => false })
      stub_slack!(slack_double)
      expect{subject.send_channel_invite('channel_id', 'user_id')}.to raise_error(SlackAdapter::SlackTeamInviteError)
    end
  end

  describe "#channel_url" do
    it "returns url of a name sanitized for a channel" do
      name = "sweet channel"
      expect(subject.channel_url(name)).to eq "https://test-team.slack.com/messages/sweet-channel/"
    end
  end

  describe "#find_channel_by_name" do
    it "returns the channel if found" do
      channel_list = { "channels" => [ { "name" => "found!"} ] }
      slack_double = double(channels_list: channel_list)
      stub_slack!(slack_double)
      expect(subject.find_channel_by_name("found!")).to eq({ "name" => "found!" })
    end
  end

  describe "#find_channel_id_by_name" do
    it "returns the id of the found channel" do
      channel_list = { "channels" => [ { "name" => "found!", "id" => 42} ] }
      slack_double = double(channels_list: channel_list)
      stub_slack!(slack_double)
      expect(subject.find_channel_id_by_name("found!")).to eq(42)
    end
  end

  describe "#sanitize_channel_name" do
    it "removes empty spaces and replaces with dashes" do
      name = "this is a name"
      expect(subject.sanitize_channel_name(name)).to eq "this-is-a-name"
    end
  end

  describe "#user_on_team?" do
    before do
      user_list = { "members" => [{ "profile" => { "email" => "example@email.com" }} ] }
      slack_double = double(users_list: user_list)
      stub_slack!(slack_double)
    end

    it "returns true when user is on team" do
      expect(subject.user_on_team?("example@email.com")).to eq true
    end

    it "returns false when not" do
      expect(subject.user_on_team?("not_valid_email")).to eq false
    end
  end

  describe "#get_user_id_by_email" do
    it "returns the users id that it finds" do
      user_list = { "members" => [{ "id" => 42, "profile" => { "email" => "example@email.com" }} ] }
      slack_double = double(users_list: user_list)
      stub_slack!(slack_double)
      expect(subject.get_user_id_by_email("example@email.com")).to eq 42
    end
  end
end

def stub_slack!(double)
  allow_any_instance_of(SlackAdapter).to receive(:slack).and_return(double)
end
