class CreateProjectMembership
  attr_reader :user, :project
  def initialize(user, project)
    @user = user
    @project = project
  end

  def perform
    create_membership
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_membership
    ProjectMembership.create!(user: user, project: project)
  end
end
