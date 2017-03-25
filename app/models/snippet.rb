class Snippet < ApplicationRecord
  include Swagger::SnippetSchema

  validates :content, presence: true

  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :stars, foreign_key: 'snippet_id'
  has_many :starring_users, through: :stars, class_name: 'User'

  concerning :Pagination do
    class_methods do
      def total_pages(author_id = nil)
        relation = author_id ? where(author_id: author_id) : page(1)
        relation.total_pages
      end

      def page_out_of_range?(page, author_id = nil)
        relation = author_id ? where(author_id: author_id).page(page) : page(page)
        relation.out_of_range?
      end
    end
  end
end
