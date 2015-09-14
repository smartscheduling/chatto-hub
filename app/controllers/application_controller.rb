class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if warden.authenticate
      super
    else
      GuestUser.new
    end
  end

  def authenticate_user_for_slack!
    unless current_user.on_slack_team?
      if !current_user.authenticated?
        flash[:notice] = "Sign in to get an invitation to the Critical Data Slack team."
      else
        flash[:notice] = slack_resend_message
      end
      redirect_to root_path
    end
  end

  protected

  def slack_resend_message
    "You have not accepted the Slack Invitation to the Critical Data team.  Check your email to redeem invitation."
  end
end
