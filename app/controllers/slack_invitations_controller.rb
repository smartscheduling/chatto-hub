class SlackInvitationsController < ApplicationController
  before_action :authenticate_user_for_slack!, only: :create

  def create
    project = Project.find(params[:project_id])
    adapter = SlackAdapter.new
    user_id = adapter.get_user_id_by_email(current_user.email)

    if adapter.send_channel_invite(project.channel_id, user_id)
      flash[:notice] = "Success! Added to the slack channel"
    else
      flash[:error] = "Error, something went wrong"
    end
    redirect_to projects_path
  end
end
