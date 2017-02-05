class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_secure_password

  has_many :snippets, foreign_key: 'author_id'
  has_many :comments, foreign_key: 'comment_author_id'
  has_many :stars, foreign_key: 'user_id'
  has_many :starred_snippets, through: :stars, class_name: 'Snippet'
end
