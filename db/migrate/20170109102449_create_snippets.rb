class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :content, null: false
      t.references :author

      t.timestamps
    end
    add_foreign_key :snippets, :users, column: :author_id
  end
end
