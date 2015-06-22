class AddChannelIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :channel_id, :string
  end
end
