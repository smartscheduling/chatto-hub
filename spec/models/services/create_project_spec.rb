require 'rails_helper'

describe CreateProject do
  describe "#perform" do
    let(:params) { { name: "Smart Scheduling" } }
    let(:user) { FactoryGirl.create(:user) }

    it "creates a project" do
      expect(Project.count).to eq 0
      CreateProject.new(user, params).perform
      expect(Project.count).to eq 1
      expect(Project.last.name).to eq "Smart Scheduling"
    end

    it "creates a project membership associated with the project" do
      expect(ProjectMembership.count).to eq 0
      CreateProject.new(user, params).perform
      expect(ProjectMembership.count).to eq 1
      expect(Project.last.users).to include(user)
    end

    it "returns true if successful" do
      expect(CreateProject.new(user, params).perform).to eq true
    end

    it "returns false if unsuccessful" do
      params = {} # fails name validation
      expect(CreateProject.new(user, params).perform).to eq false
    end
  end
end
