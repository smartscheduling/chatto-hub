class ProjectForm
  include ActiveModel::Model
  include Virtus.model

  attribute :name, String
  attribute :description, String
  attribute :user, User
  attribute :slack, SlackAdapter
  attribute :github, GithubAdapter

  validates :name,
    presence: true
  validate :channel_doesnt_exist

  attr_accessor :project

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!
    @project = create_project
    @membership = @project.project_memberships.create!(user: user)
    create_slack_channel
    create_github_team
  end

  private

  def channel_doesnt_exist
    if slack.find_channel_by_name(name)
      errors[:channel] << "name already exists.  Pick new name for your project"
    end
  end

  def create_project
    project = Project.new(name: name, description: description)
    project.creator_id = user.id
    project.save!
    project
  end

  def create_slack_channel
    channel = slack.channels_create(name: name)
    channel_url = slack.channel_url(name)

    if channel["ok"]
      id = channel["channel"]["id"]
      project.channel_id = id
      project.url = channel_url
      project.save!
    else
      false
    end
  end

  def create_github_team
    github.create_team(name, description)
  rescue RestClient::UnprocessableEntity
    errors[:github] << "wasn't able to create your new team."
  end
end
