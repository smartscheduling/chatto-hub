class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @projects = Project.all.limit(25)
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = CreateProject.new(current_user, project_params)
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to projects_path
    else
      flash[:error] = @project.errors.full_messages.join(', ')
      redirect_to :back
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
