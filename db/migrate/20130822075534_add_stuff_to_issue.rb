class AddStuffToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :correction, :text
    add_column :issues, :impact, :string
    add_column :issues, :review_ref, :string
    add_column :issues, :validation_ref, :string
  end
end
