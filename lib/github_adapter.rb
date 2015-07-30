require 'rest-client'

class GithubAdapter
  cattr_accessor :user, :password

  def resource
    @resource ||= RestClient::Resource.new('https://api.github.com/orgs/chatto-hub-test2/teams', user, password)
  end

  def create_team(name, description)
    response = resource.post({
      name: name,
      description: description
    }.to_json, content_type: 'application/json')
    JSON.parse(response)
  end
end
