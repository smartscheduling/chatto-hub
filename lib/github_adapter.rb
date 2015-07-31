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
    }.to_json, content_type: 'application/json')
    JSON.parse(response)
  end

  def invite_to_team(team_id, username)
    resource = create_resource("https://api.github.com/teams/#{team_id}/memberships/#{username}")
    response = resource.put({}.to_json, content_type: 'application/json')
    JSON.parse(response)
  end

  # ARGS: <Name> <Description> <Team_id>
  def create_org_repo(args={})
    resource = create_resource("https://api.github.com/orgs/chatto-hub-test2/repos")
    response = resource.post(args.to_json, content_type:'application/json')
    JSON.parse(response)
  end

  def fork_repo(create_repo_result)
    git = Git.clone(
      ENV['CHATTO_HUB_OPEN_SOURCE_URL'],
      create_repo_result['name'], path:  '/tmp/checkout'
    )
    git.add_remote('new-origin', create_repo_result['clone_url'])
    git.push(git.remote('new-origin'))
  end

  private

  def create_resource(url)
    RestClient::Resource.new(url, user, password)
  end
end
