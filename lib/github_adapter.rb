require 'rest-client'

class GithubAdapter
  cattr_accessor :user, :password

  def create_team_resource
    @resource ||= RestClient::Resource.new(
      'https://api.github.com/orgs/chatto-hub-test2/teams',
      user, password
    )
  end

  def create_team(name, description)
    response = create_team_resource.post({
      name: name,
      description: description
    }.to_json, content_type: 'application/json')
    JSON.parse(response)
  end

  def invite_to_team(team_id, username)
    resource = RestClient::Resource.new(
      "https://api.github.com/teams/#{team_id}/memberships/#{username}",
      user, password
    )
    resp = resource.put({}.to_json, content_type: 'application/json')
    JSON.parse(resp)
  end
end
