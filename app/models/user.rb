class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  has_many :project_memberships
  has_many :projects, through: :project_memberships

  after_create :slack_team_invite, unless: :skip_callbacks

  def authenticated?
    true
  end

  def slack_team_invite
    slack_adapter.send_team_invite(email)
  end

  def self.github_from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth["info"]["nickname"]
      user.image = auth["info"]["image"]
    end
  end

  def on_slack_team?
    slack_adapter.user_on_team?(email)
  end

  def on_github_organization?
    return true if github_verified
    on_team = github_adapter.member_in_organization?(nickname)
    update(github_verified: on_team)
    on_team
  end

  protected

  def github_adapter
    @github_adapter ||= GithubAdapter.new
  end

  def slack_adapter
    @slack_adapter ||= SlackAdapter.new
  end
end
