class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    if params[:q]
      @projects = Project.search(params[:q][:search])
      @results = @projects.count
    else
      @projects = Project.all.order(created_at: :desc).limit(100)
    end
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
      flash.now[:notice] = @project.errors.full_messages.join(".  ").html_safe
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

  # TODO:
  # - archive slack channel
  # - delete github repo
  def destroy
    @project = Project.find(params[:id])
    SlackAdapter.new.channels_archive(channel: @project.channel_id)
    if @project.destroy
      redirect_to :back, notice: "Successfully deleted project"
    end
  end

  private

  def project_form_params
    params.require(:project_form).permit(:name, :description)
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
