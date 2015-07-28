class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.github_from_omniauth(auth)
    @user.update(token: auth["credentials"]["token"])
    # github = Github.new(client_id: ENV['GITHUB_APP_ID'], client_secret: ENV['GITHUB_APP_SECRET'])
    # auth_url = github.authorize_url scope: 'admin:org'
    # binding.pry
    # sign_in(:user, user)
    # redirect_to root_path
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, user: @user.nickname) if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end

