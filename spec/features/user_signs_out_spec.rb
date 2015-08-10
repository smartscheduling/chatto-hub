require 'rails_helper'

feature 'user signs out', %Q{
  As an authenticated user
  I want to sign out
  So that my identity is forgotten about on the machine I'm using
} do
  # Acceptance Criteria
  # * If I'm signed in, i have an option to sign out
  # * When I opt to sign out, I get a confirmation that my identity has been
  #   forgotten on the machine I'm using

  scenario 'authenticated user signs out' do
    allow_any_instance_of(SlackAdapter).to receive(:send_team_invite).and_return(true)
    allow_any_instance_of(User).to receive(:on_slack_team?).and_return(true)
    mock_github_auth!

    visit root_path
    find(:css, '#sign-in').click

    click_link "Sign in with Github"
    expect(page.source).to match(/Welcome back!/)

    click_on 'Sign Out'
    expect(page.source).to match(/Signed out successfully/)
  end

  scenario 'unauthenticated user attempts to sign out' do
    visit '/'
    expect(page).to_not have_content('Sign Out')
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

