class Star < ApplicationRecord
  belongs_to :starring_user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :starred_snippet, foreign_key: 'snippet_id', class_name: 'Snippet'
end
