module Swagger::SnippetSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Snippet do
      property :title do
        key :type, :string
      end
      property :content do
        key :type, :string
      end
    end

    swagger_schema :SnippetInput do
      allOf do
        schema do
          key '$ref', :Snippet
        end
        schema do
          key :required, [:content]
        end
      end
    end

    swagger_schema :SnippetOutput do
      key :required, [:id, :title, :content, :author]
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :title do
        key :type, :string
      end
      property :content do
        key :type, :string
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
    end
  end
end
