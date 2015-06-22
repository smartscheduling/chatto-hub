class CreateProject
  include ActiveModel::Validations

  attr_reader :user, :params, :slack_client
  def initialize(user, params, slack_client=nil)
    @user = user
    @params = params
    @slack_client = slack_client || SlackAdapter.new
  end

  validate :channel_exists?

  def save
    if valid?
      persist!
    else
      false
    end
  end

  def channel_exists?
    if slack_client.find_channel_by_name(params["name"])
      errors[:channel] << "or project already exists. Pick new name"
    end
  end

  private

  def persist!
    project = create_project
    create_associated_membership(project)
  end

  def create_project
    project = Project.new(params)
    project.creator_id = user.id
    project.save!
    project
  end

  def create_associated_membership(project)
    ProjectMembership.create!(project: project, user: user)
  end
end
