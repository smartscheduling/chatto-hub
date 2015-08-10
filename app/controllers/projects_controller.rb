class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @projects = Project.all.limit(50)
  end

  def new
    @project = ProjectForm.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = ProjectForm.new(project_form_params.merge(
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

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "Successfully updated project."
    end
    redirect_to projects_path
  end

  private

  def project_form_params
    params.require(:project_form).permit(:name, :description)
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
