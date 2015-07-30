require "rails_helper"

class ControllerSubClass < ApplicationController; end

describe ControllerSubClass do
  controller do
    def index
      authenticate_user_for_slack!
    end
  end

  describe "#authenticate_user_for_slack!" do
    before do
      allow_any_instance_of(SlackAdapter).to receive(:user_on_team?).
        and_return(false)
    end

    it "redirects to root path" do
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq "Sign in to get invite for slack team"
    end
  end
end
