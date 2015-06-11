class CreateProjectMembership < ActiveRecord::Migration
  def change
    create_table :project_memberships do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
