require 'rails_helper'

describe CreateProject do
  describe "#perform" do
    let(:params) { { name: "Smart Scheduling" } }
    let(:user) { FactoryGirl.create(:user) }

    it "creates a project" do
      stub_slack!
      expect(Project.count).to eq 0
      CreateProject.new(user, params).perform
      expect(Project.count).to eq 1
      expect(Project.last.name).to eq "Smart Scheduling"
    end

    it "creates a project membership associated with the project" do
      stub_slack!
      expect(ProjectMembership.count).to eq 0
      CreateProject.new(user, params).perform
      expect(ProjectMembership.count).to eq 1
      expect(Project.last.users).to include(user)
    end

    it "returns true if successful" do
      stub_slack!
      expect(CreateProject.new(user, params).perform).to eq true
    end

    it "returns false if unsuccessful" do
      stub_slack!
      params = {} # fails name validation
      expect(CreateProject.new(user, params).perform).to eq false
    end
  end
end

def stub_slack!
  allow_any_instance_of(SlackAdapter).to receive(:channels_create).and_return(true)
  allow_any_instance_of(CreateProject).to receive(:handle_slack_logic).and_return(true)
end

def channel_exists?(channel_name)
  Slack.channels_list["channels"].any? { |c| c["name"] == channel_name }
end
