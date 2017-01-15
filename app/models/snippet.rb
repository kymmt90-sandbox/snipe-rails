class Snippet < ApplicationRecord
  validates :content, presence: true

  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :stars, foreign_key: 'snippet_id'
  has_many :starring_users, through: :stars, class_name: 'User'
end
