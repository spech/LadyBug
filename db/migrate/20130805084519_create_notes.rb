class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :body
      t.references :issue, index: true

      t.timestamps
    end
  end
end
