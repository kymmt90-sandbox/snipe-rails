class Comment < ApplicationRecord
  include Swagger::CommentSchema

  belongs_to :comment_author, class_name: 'User'
  belongs_to :snippet

  validates :content, presence: true
end
