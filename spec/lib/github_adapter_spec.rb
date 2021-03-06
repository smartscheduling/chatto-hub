require "rails_helper"

GithubAdapter.user = "example_user"
GithubAdapter.password = "example_password"

describe GithubAdapter do
  subject { described_class.new }

  describe "#team_resource" do
    it "returns a RestClient resource with proper parameters" do
      github_url = "https://api.github.com/orgs/chatto-hub-test2/teams"

      expect(RestClient::Resource).to receive(:new).
        with(github_url, "example_user", "example_password")

      subject.team_resource
    end
  end

  describe "#create_team" do
    it "sends a post to the api with name/description parameters" do
      name = "Project name"
      desc = "Project description"

      expect_any_instance_of(RestClient::Resource).to receive(:post).with(
        { name: name, description: desc, permission: "admin" }.to_json,
        content_type: "application/json"
      ).and_return({ ok: true }.to_json)

      subject.create_team(name, desc)
    end
  end

  describe "#invite_to_team" do
    it "sends a put with the proper end point" do
      team_id = "42"
      username = "spencercdixon"
      github_url = "https://api.github.com/teams/#{team_id}/memberships/#{username}"

      expect(RestClient::Resource).to receive(:new).
        with(github_url, "example_user", "example_password").
        and_return(double(put: {}.to_json))

      subject.invite_to_team(team_id, username)
    end
  end

  describe "#create_org_repo" do
    it "calls POST with proper parameters" do
      github_url = "https://api.github.com/orgs/chatto-hub-test2/repos"

      expect(RestClient::Resource).to receive(:new).
        with(github_url, "example_user", "example_password").
        and_return(double(post: {}.to_json))

      subject.create_org_repo
    end
  end

  describe "#clone_repo" do
    it "executes sh script" do
      expect(subject).to receive(:system)
      subject.clone_repo("example_project", "example_project.git")
    end
  end
end
