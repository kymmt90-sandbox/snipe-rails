module Swagger::CommentSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Comment do
      property :content do
        key :type, :string
      end
    end

    swagger_schema :CommentInput do
      allOf do
        schema do
          key '$ref', :Comment
        end
        schema do
          key :required, [:content]
        end
      end
    end

    swagger_schema :CommentOutput do
      allOf do
        schema do
          key '$ref', :Comment
        end
        schema do
          key :required, [:id, :content, :author, :snippet_id]
          property :id do
            key :type, :integer
            key :format, :int64
          end
          property :author do
            key :type, :object
            key :required, [:id, :name]
            property :id do
              key :type, :integer
              key :format, :int64
            end
            property :name do
              key :type, :string
            end
          end
          property :snippet_id do
            key :type, :integer
            key :format, :int64
          end
        end
      end
    end
  end
end
