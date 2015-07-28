require 'net/https'
require 'uri'

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
      slack: SlackAdapter.new
    ))
    binding.pry
    auth_result = JSON.parse(RestClient.post('https://api.github.com/orgs/Chatto-Hub-Test/teams',
                             access_token: ENV['GITHUB_APP_TOKEN'],
                             name: "#{project_params[:name]}",
                             description: "#{project_params[:description]}"))

    binding.pry
    # uri = URI.parse("https://api.github.com/orgs/Chatto-Hub-Test/teams")
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true

    # headers = { "Authentication" => "token" }
    # request = Net::HTTP::Post.new(uri.request_uri, headers)
    # request.body = "{name: #{project_params[:name]}, description: #{project_params[:description]}}".to_json
    # request["Authorization"] = ENV['GITHUB_APP_TOKEN']
    # request["content-type"] = "application/json"
    # response = http.request(request)
    # response.body
    # binding.pry

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
