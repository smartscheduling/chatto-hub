class AddGithubTeamIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_team_id, :integer
  end
end
