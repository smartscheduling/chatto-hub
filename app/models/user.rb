class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  has_many :project_memberships
  has_many :projects, through: :project_memberships

  after_create :slack_team_invite

  def slack_team_invite
    SlackAdapter.new.send_team_invite(email)
  end

  def authenticated?
    true
  end

  def self.github_from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth["info"]["nickname"]
      user.image = auth["info"]["image"]
    end
  end
end
