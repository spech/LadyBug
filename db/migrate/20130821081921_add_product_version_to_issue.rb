class AddProductVersionToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :product_version, :integer
  end
end
