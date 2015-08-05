class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.github_from_omniauth(auth)

    if @user.persisted?
      sign_in @user
      flash[:notice] = @user.on_slack_team? ? "Welcome back!" : "Please check email for Slack invitation and accept."
      redirect_to root_path
    else
      redirect_to new_user_registration_url
    end
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end

