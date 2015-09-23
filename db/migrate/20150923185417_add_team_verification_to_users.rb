class AddTeamVerificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_verified, :boolean
  end
end
