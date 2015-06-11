class ProjectMembershipsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    project = Project.find(params[:project_id])
    if CreateProjectMembership.new(current_user, project).perform
      flash[:notice] = "Successfully joined project"
    else
      flash[:notice] = "Failure"
    end

    redirect_to projects_path
  end
end
