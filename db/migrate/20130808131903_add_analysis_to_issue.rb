class AddAnalysisToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :analysis, :text
  end
end
