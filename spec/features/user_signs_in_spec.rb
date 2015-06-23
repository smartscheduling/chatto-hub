require 'rails_helper'

feature 'user signs in', %Q{
  As a signed up user
  I want to sign in
  So that I can regain access to my account
} do

  context "github omniauth" do
    scenario "successful sign up" do
      allow_any_instance_of(SlackAdapter).to receive(:send_team_invite).and_return(true)
      mock_github_auth!

      visit root_path
      find(:css, '#sign-in').click

      click_link "Sign in with Github"

      expect(page).to have_content("Successfully signed in as boblob.")
      expect(User.count).to eq(1)
    end

    scenario "failure to sign up with invalid credentials" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit root_path

      find(:css, '#sign-in').click
      click_link "Sign in with Github"

      expect(page).to have_content("Unable to sign in.")
      expect(page).to have_link("Sign in with Github", new_user_session_path)
      expect(User.count).to eq(0)
    end
  end

end

def mock_github_auth!
  OmniAuth.config.mock_auth[:github] = {
    "provider" => "github",
    "uid" => "123456",
    "info" => {
      "nickname" => "boblob",
      "email" => "bob@example.com",
      "name" => "Bob Loblaw",
      "image" => "http://www.s3link.com"
    },
    "credentials" => {
      "token" => "12345"
    }
  }
end

