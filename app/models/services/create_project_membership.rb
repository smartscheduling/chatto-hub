class CreateProjectMembership
  attr_reader :user, :project, :slack_client
  def initialize(user, project, slack_client=nil)
    @user = user
    @project = project
    @slack_client = slack_client || SlackAdapter.new
  end

  def perform
    create_membership
    send_slack_invite
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def create_membership
    pm = ProjectMembership.new(user: user, project: project)
    pm.save!
  end

  def send_slack_invite
    channel = slack_client.find_channel_by_name(project.name)
    if channel
      channel_id = channel["id"]

      if slack_client.user_on_team?(user.email)
        user_id = slack_client.get_user_id_by_email(user.email)
        slack_client.send_channel_invite(channel_id, user_id)
      else
        slack_client.send_team_invite(user.email, channel_id)
      end
    else
      false
    end
  end
end
