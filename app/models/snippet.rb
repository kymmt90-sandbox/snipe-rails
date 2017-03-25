class Snippet < ApplicationRecord
  include Swagger::SnippetSchema

  validates :content, presence: true

  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :stars, foreign_key: 'snippet_id'
  has_many :starring_users, through: :stars, class_name: 'User'

  def self.total_pages(author_id = nil)
    if author_id
      where(author_id: author_id).total_pages
    else
      page(1).total_pages
    end
  end
end
