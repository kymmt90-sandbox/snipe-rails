class ChangeCommentsContentType < ActiveRecord::Migration[5.0]
  def up
    change_column :comments, :content, :text, null: false
  end

  def down
    change_column :comments, :content, :string, null: false
  end
end
