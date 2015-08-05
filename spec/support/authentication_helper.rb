module AuthenticationHelper
  def sign_in_as(user)
    mock_github_user_auth!(user)

    visit root_path
    find(:css, '#sign-in').click

    click_on 'Sign in with Github'
  end

  def mock_github_user_auth!(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "provider" => "github",
      "uid" => "123456",
      "info" => {
        "nickname" => user.nickname,
        "email" => user.email,
        "name" => user.first_name,
        "image" => "http://www.s3link.com"
      },
      "credentials" => {
        "token" => "12345"
      }
    })
  end
end

