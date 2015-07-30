require "rails_helper"

GithubAdapter.user = "example_user"
GithubAdapter.password = "example_password"

describe GithubAdapter do
  subject { described_class.new }

  describe "#resource" do
    it "returns a RestClient resource with proper parameters" do
      github_url = "https://api.github.com/orgs/chatto-hub-test2/teams"
      expect(RestClient::Resource).to receive(:new).with(github_url, "example_user", "example_password")
      subject.resource
    end
  end

  describe "#create_team" do
    it "sends a post to the api with name/description parameters" do
      name = "Project name"
      desc = "Project description"

      expect_any_instance_of(RestClient::Resource).to receive(:post).with(
        { name: name, description: desc }.to_json,
        content_type: "application/json"
      ).and_return({ok: true}.to_json)

      subject.create_team(name, desc)
    end
  end
end
