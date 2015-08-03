require 'rest-client'

class GithubAdapter
  cattr_accessor :user, :password

  def team_resource
    create_resource("https://api.github.com/orgs/chatto-hub-test2/teams")
  end

  def create_team(name, description)
    response = team_resource.post({
      name: name,
      description: description
    }.to_json, content_type: "application/json")
    JSON.parse(response)
  end

  def invite_to_team(team_id, username)
    resource = create_resource("https://api.github.com/teams/#{team_id}/memberships/#{username}")
    response = resource.put({}.to_json, content_type: "application/json")
    JSON.parse(response)
  end

  # ARGS: <Name> <Description> <Team_id>
  def create_org_repo(args = {})
    resource = create_resource("https://api.github.com/orgs/chatto-hub-test2/repos")
    response = resource.post(args.to_json, content_type: "application/json")
    JSON.parse(response)
  end

  def add_repo_to_team(team_id, repo_name)
    resource = create_resource(
      "https://api.github.com/teams/#{team_id}/repos/chatto-hub-test2/#{repo_name}",
      { "Accept" => "application/vnd.github.ironman-preview+json" } ) # Required by Github API
    resource.put( { permission: 'admin' }.to_json, content_type: "application/json")
  end

  def fork_repo(project_name, full_name_git)
    system(
      'sh',
      ENV['CHATTO_HUB_ADMIN_GIT_FORK_SH'],
      ENV['CHATTO_HUB_ADMIN_GIT_USER'],
      ENV['ROOT_REPO_URI'],
      project_name,
      full_name_git
    )
  end

  private

  def create_resource(url, headers = nil)
    if headers
      RestClient::Resource.new(url, user: user, password: password, headers: headers)
    else
      RestClient::Resource.new(url, user, password)
    end
  end
end
