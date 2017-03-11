module Swagger::CommentApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{snippet_id}/comments' do
      parameter :snippet_id do
        key :name, :snippet_id
      end

      operation :get do
        key :description, 'Returns comments of the snippet'
        key :operationId, :find_comments_by_snippet_id

        response 200 do
          key :description, 'Comments of the snippet specified by its ID'
          schema type: :array do
            items do
              key :'$ref', :CommentOutput
            end
          end
        end

        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError
      end

      operation :post do
        key :description, 'Creates a comment'
        key :operationId, :create_comment

        parameter :comment

        response 201 do
          key :description, 'Created comment'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end
    end

    swagger_path '/comments/{id}' do
      parameter :comment_id do
        key :name, :id
      end

      operation :get do
        key :description, "Returns the specified comment"
        key :operationId, :find_comment_by_id

        response 200 do
          key :description, 'Comment specified by its ID'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError
      end

      operation :patch do
        key :description, 'Updates the comment'
        key :operationId, :update_comment

        parameter :comment

        response 201 do
          key :description, 'Updated comment'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes the comment'
        key :operationId, :delete_comment

        response 204 do
          key :description, 'The comment was deleted'
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end
    end
  end
end
