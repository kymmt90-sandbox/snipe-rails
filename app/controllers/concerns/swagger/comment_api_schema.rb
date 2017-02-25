module Swagger::CommentApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{snippet_id}/comments' do
      parameter do
        key :name, :snippet_id
        key :in, :path
        key :description, 'Snippet ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      operation :get do
        key :description, 'Returns comments of the snippet'
        key :operationId, 'findComments'

        response 200 do
          key :description, 'The comments response'
          schema type: :array do
            items do
              key :'$ref', :CommentOutput
            end
          end
        end
      end

      operation :post do
        key :description, 'Creates a comment'
        key :operationId, 'createSnippet'

        parameter do
          key :name, :comment
          key :in, :body
          key :description, 'The created comment'
          key :required, true
          schema do
            key :'$ref', :CommentInput
          end
        end

        response 201 do
          key :description, 'The created comment response'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        security api_key: []
      end
    end

    swagger_path '/comments/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Comment ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      operation :get do
        key :description, "Returns a comment"
        key :operationId, 'findCommentById'

        response 200 do
          key :description, 'The comment response'
          schema do
            key :'$ref', :CommentOutput
          end
        end
      end

      operation :patch do
        key :description, 'Updates a comment'
        key :operationId, 'updateSnippet'

        parameter do
          key :name, :comment
          key :in, :body
          key :description, 'The updated comment'
          key :required, true
          schema do
            key :'$ref', :CommentInput
          end
        end

        response 201 do
          key :description, 'The updated comment response'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes a comment'
        key :operationId, 'deleteComment'

        response 204 do
          key :description, 'No content'
        end

        security api_key: []
      end
    end
  end
end
