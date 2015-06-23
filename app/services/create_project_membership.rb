class CreateProjectMembership
  attr_reader :user, :project, :slack_client
  def initialize(user, project, slack_client=nil)
    @user = user
    @project = project
    @slack_client = slack_client || SlackAdapter.new
  end

  def perform
    create_membership
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_membership
    pm = ProjectMembership.new(user: user, project: project)
    pm.save!
  end
end
