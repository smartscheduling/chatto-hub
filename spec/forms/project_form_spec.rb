require 'rails_helper'

describe ProjectForm do
  describe "validations" do
    context "slack channel already exists" do
      it "adds an error to the form object" do
        user = FactoryGirl.create(:user)
        slack = double(find_channel_by_name: true)
        form = ProjectForm.new(name: "name", description: "description", user: user, slack: slack, github: double)
        form.valid?
        expect(form.errors[:channel]).to include "name already exists.  Pick new name for your project"
      end
    end
  end

  describe "#save" do
    context "when valid" do
      it "calls persist!" do
        user = FactoryGirl.create(:user)
        form = ProjectForm.new(
          name: "name", description: "description",
          user: user, slack: slack_double, github: double
        )
        expect(form).to receive(:persist!).and_return(true)
        form.save
      end
    end

    context "when invalid" do
      it "returns false" do
        form = ProjectForm.new(name: "", description: "description", slack: slack_double)
        expect(form.save).to eq false
      end
    end
  end

  describe "#persist!" do
    context "without slack/github" do
      let(:user) { FactoryGirl.create(:user) }
      let(:form) { ProjectForm.new(name: "sample project", description: '', user: user, slack: slack_double, github: double) }

      before do
        stub_slack_and_github!(form)
      end

      it "creates a project" do
        expect(Project.count).to eq 0
        form.persist!
        expect(Project.count).to eq 1
      end

      it "creates a project membership" do
        expect(ProjectMembership.count).to eq 0
        form.persist!
        expect(ProjectMembership.count).to eq 1
      end

      it "calls #create_slack_channel" do
        expect(form).to receive(:create_slack_channel)
        form.persist!
      end

      it "calls #create_slack_channel" do
        expect(form).to receive(:create_github_team)
        form.persist!
      end
    end

    context "slack creation" do
      let(:channel_url) { "slack channel url" }
      let(:channel)     { { "ok" => true, "channel" => { "id" => "channel id" } } }
      let(:slack)       { double(channels_create: channel, channel_url: channel_url) }
      let(:github)      { github_persist_double }
      let(:user) { FactoryGirl.create(:user) }
      let(:form) { ProjectForm.new(
        name: "sample project", description: '',
        user: user, slack: slack, github: github)
      }
      let(:project) { Project.first }

      before do
        form.persist!
      end

      it "saves slack channel id to the project" do
        expect(project.channel_id).to eq "channel id"
      end

      it "saves channel url to the project" do
        expect(project.url).to eq "slack channel url"
      end

      it "saves the github team id" do
        expect(project.github_team_id).to eq 42
      end
    end
  end
end

def slack_double
  double(find_channel_by_name: false)
end

def github_persist_double
  double(
    create_team: { "id" => 42 },
    invite_to_team: true,
    create_org_repo: true,
    fork_repo: true
  )
end

def stub_slack_and_github!(form)
  allow(form).to receive(:create_slack_channel).and_return(true)
  allow(form).to receive(:create_github_team).and_return(true)
  allow(form).to receive(:invite_to_github_team).and_return(true)
  allow(form).to receive(:create_new_repo_on_organization).and_return(true)
end
