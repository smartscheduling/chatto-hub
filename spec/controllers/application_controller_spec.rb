require "rails_helper"

class ControllerSubClass < ApplicationController; end

describe ControllerSubClass do
  controller do
    def index
      authenticate_user_for_slack!
    end
  end

  describe "#authenticate_user_for_slack!" do
    context "unauthenticated user" do
      it "redirects to root path and prompts sign in" do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq "Sign in to get an invitation to the Critical Data Slack team."
      end
    end

    context "authenticated user who isn't on team" do
      let(:user) { FactoryGirl.create(:user, sign_in_count: 1) }

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        allow_any_instance_of(User).to receive(:on_slack_team?).and_return false
      end

      it "sets different message for signed in user" do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq "You have not accepted the Slack Invitation to the Critical Data team.  Check your email to redeem invitation."
      end
    end
  end
end
