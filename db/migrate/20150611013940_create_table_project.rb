class CreateTableProject < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :creator_id, null: false
      t.text :description

      t.timestamps
    end
  end
end
