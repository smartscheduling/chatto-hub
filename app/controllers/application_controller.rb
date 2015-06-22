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
    adapter = SlackAdapter.new

    unless adapter.user_on_team?(current_user.email)
      flash[:notice] = "Register in order to join slack team"
      redirect_to new_user_registration_path
    end
  end
end
