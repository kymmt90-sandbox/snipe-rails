class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_secure_password

  has_many :comments, foreign_key: 'comment_author_id'
end
