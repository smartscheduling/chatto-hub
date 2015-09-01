class ProjectForm
  include ActiveModel::Model
  include Virtus.model

  attribute :name, String
  attribute :description, String
  attribute :user, User
  attribute :slack, SlackAdapter
  attribute :github, GithubAdapter

  validates :name,
    presence: true,
    length: { in: 0..21 },
    format: {
      with: /\A\w+\s*\w+\z/,
      message: "only allows letters."
    }
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
    invite_to_github_team
    create_and_clone_repo
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
      project.update!(channel_id: id, url: channel_url)
    end
  end

  def create_github_team
    resp = github.create_team(name, description)
    project.update!(github_team_id: resp["id"])
  end

  def invite_to_github_team
    team_id = project.github_team_id
    username = user.nickname
    github.invite_to_team(team_id, username)
  end

  def create_and_clone_repo
    args = {
      name: name,
      description: description,
      team_id: project.github_team_id
    }
    repo_results = github.create_org_repo(args)
    project.update!(github_url: repo_results["html_url"])
    clone_repo(repo_results)
  end

  private

  def clone_repo(repo_results)
    github.add_repo_to_team(project.github_team_id, repo_results["name"])
    github.clone_repo(name, repo_results["full_name"])
  end
end
