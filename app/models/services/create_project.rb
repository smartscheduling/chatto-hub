class CreateProject
  attr_reader :user, :params, :msg_client
  def initialize(user, params, msg_client=nil)
    @user = user
    @params = params
    @msg_client = msg_client || SlackAdapter.new
  end

  def perform
    project = create_project
    create_associated_membership(project)
    handle_slack_logic(project)
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def handle_slack_logic(project)
    channel = create_slack_channel(project.name)
    channel_id = channel["channel"]["id"]
    if user_is_on_slack_team?
      slack_channel_invite(channel_id, slack_user_id)
    else
      slack_team_invite(user.email, channel_id)
    end
  end

  def create_project
    project = Project.new(params)
    project.creator_id = user.id
    project.save!
    project
  end

  def create_associated_membership(project)
    pm = ProjectMembership.new(project: project, user: user)
    pm.save!
  end

  def slack_user_id
    msg_client.get_user_id_by_email(user.email)
  end

  def user_is_on_slack_team?
    msg_client.user_on_team?(user.email)
  end

  def slack_team_invite(email, channel_id)
    msg_client.team_invite(email, channel_id)
  end

  def slack_channel_invite(cid, uid)
    msg_client.send_channel_invite(cid, uid)
  end

  def create_slack_channel(name)
    msg_client.channels_create(name: name)
  end
end
