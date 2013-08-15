class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :number
      t.integer :state
      t.integer :project_id

      t.timestamps
    end
  end
end
