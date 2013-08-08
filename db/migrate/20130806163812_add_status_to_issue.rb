class AddStatusToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :state, :integer
  end
end
