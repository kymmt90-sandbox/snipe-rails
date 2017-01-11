class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :content, null: false
      t.references :author, foreign_key: true

      t.timestamps
    end
  end
end
