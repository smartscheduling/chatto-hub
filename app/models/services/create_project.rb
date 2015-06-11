class CreateProject
  attr_reader :user, :params
  def initialize(user, params)
    @user = user
    @params = params
  end

  def perform
    project = create_project
    create_project_membership(project)
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_project
    project = Project.new(params)
    project.creator_id = user.id
    project.save!
    project
  end

  def create_project_membership(project)
    pm = ProjectMembership.new(project: project, user: user)
    pm.save!
  end
end
