class AddTargetVersionToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :target_version, :integer
    add_column :issues, :severity, :string
  end
end
