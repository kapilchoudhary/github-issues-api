class AddTitleToIssue < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :title, :string
    add_column :issues, :description, :text
    add_reference :issues, :user, foreign_key: true, index: true
  end
end
