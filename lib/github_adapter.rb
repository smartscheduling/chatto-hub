require "rest-client"

class GithubAdapter
  cattr_accessor :user, :password, :github_organization

  def team_resource
    create_resource("https://api.github.com/orgs/#{github_organization}/teams")
  end

  def organization_members
    resource = create_resource("https://api.github.com/orgs/#{github_organization}/members")
    response = resource.get
    JSON.parse(response)
  end

  def create_team(name, description)
    response = team_resource.post({
      name: name,
      description: description,
      permission: 'admin'
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
    resource = create_resource("https://api.github.com/orgs/#{github_organization}/repos")
    response = resource.post(args.to_json, content_type: "application/json")
    JSON.parse(response)
  end

  def add_repo_to_team(team_id, repo_name)
    resource = create_resource(
      "https://api.github.com/teams/#{team_id}/repos/#{github_organization}/#{repo_name}",
      { "Accept" => "application/vnd.github.ironman-preview+json" } ) # Required by Github API
    resource.put( { permission: "admin" }.to_json, content_type: "application/json")
  end

  def clone_repo(project_name, full_name)
    root_repo_uri = "https://#{user}:#{password}@github.com/#{ENV['ROOT_REPO_URI']}.git"
    new_repo_uri  = "https://#{user}:#{password}@github.com/#{full_name}.git"
    system(
      "sh",
      Rails.root.join('lib','scripts','chatto_hub_clone.sh').to_s,
      root_repo_uri,
      project_name.split(' ').join('-'),
      new_repo_uri
    )
  end

  def team_members(team_id)
    resource = create_resource("https://api.github.com/teams/#{team_id}/members")
    JSON.parse(resource.get)
  end

  def member_in_organization?(username)
    members = organization_members.map { |m| m["login"] }
    members.include?(username)
  end

  # private

  def create_resource(url, headers = nil)
    if headers
      RestClient::Resource.new(url, user: user, password: password, headers: headers)
    else
      RestClient::Resource.new(url, user, password)
    end
  end
end
