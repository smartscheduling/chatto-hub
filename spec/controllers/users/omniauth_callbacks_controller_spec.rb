require "rails_helper"

describe Users::OmniauthCallbacksController do
  describe "GET #github" do
    it "redirects to new_user_registration if not successful" do
      @request.env["devise.mapping"] = Devise.mappings[:user]

      user = FactoryGirl.create(:user)
      allow(User).to receive(:github_from_omniauth).and_return(user)
      allow(user).to receive(:persisted?).and_return(false)

      get :github
      expect(response).to redirect_to new_user_registration_url
    end
  end
end
