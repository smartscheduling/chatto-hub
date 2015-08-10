module AuthenticationHelper
  def sign_in_as(user)
    allow_any_instance_of(SlackAdapter).to receive(:send_team_invite).and_return(true)
    allow_any_instance_of(User).to receive(:on_slack_team?).and_return true
    mock_github_user_auth!(user)

    visit root_path
    find(:css, '#sign-in').click

    click_on 'Sign in with Github'
  end

  def mock_github_user_auth!(user)
    OmniAuth.config.mock_auth[:github] = {
      "provider" => "github",
      "uid" => user.id,
      "info" => {
        "nickname" => user.nickname,
        "email" => user.email,
        "name" => user.first_name,
        "image" => "http://www.s3link.com"
      },
      "credentials" => {
        "token" => "12345"
      }
    }
  end
end

