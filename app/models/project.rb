class Project < ActiveRecord::Base
  belongs_to :creator,
    class_name: "User",
    foreign_key: "creator_id"

  has_many :project_memberships
  has_many :users,
    through: :project_memberships

  def self.search(query)
    where("name ilike :q or description ilike :q", q: "%#{query}%")
  end
end
