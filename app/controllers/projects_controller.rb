class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @projects = Project.all.limit(25)
  end

  def new
    @project = ProjectForm.new
  end

  def create
    @project = ProjectForm.new(project_params.merge(
      user: current_user,
      slack: SlackAdapter.new,
      github: GithubAdapter.new
    ))

    if @project.save
      redirect_to projects_path, notice: "Successfully created project."
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project_form).permit(:name, :description)
  end
end
