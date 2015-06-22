class Project < ActiveRecord::Base
  belongs_to :creator,
    class_name: "User",
    foreign_key: "creator_id"

  has_many :project_memberships
  has_many :users,
    through: :project_memberships

  validates :name,
    presence: true

  before_create :create_slack_channel

  def create_slack_channel
    channel = SlackAdapter.new.channels_create(name: name)
    if channel["ok"]
      id = channel["channel"]["id"]
      self.channel_id = id
    else
      false
    end
  end
end
