class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content, null: false
      t.references :comment_author
      t.references :snippet, foreign_key: true

      t.timestamps
    end
    add_foreign_key :comments, :users, column: :comment_author_id
  end
end
