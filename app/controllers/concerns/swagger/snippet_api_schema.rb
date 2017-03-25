module Swagger::SnippetApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{id}' do
      parameter :snippet_id do
        key :name, :id
      end

      operation :get do
        key :description, 'Returns the specified snippet'
        key :operationId, :find_snippet_by_id

        response 200 do
          key :description, 'Snippet specified by its ID'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError
      end

      operation :patch do
        key :description, 'Updates the snippet'
        key :operationId, :update_snippet

        parameter :snippet

        response 200 do
          key :description, 'Updated snippet'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes the snippet'
        key :operationId, :delete_snippet

        response 204 do
          key :description, 'The snippet was deleted'
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end
    end

    swagger_path '/users/{user_id}/snippets' do
      parameter :user_id do
        key :name, :user_id
      end

      operation :get do
        key :description, "Returns the specified user's snippets"
        key :operationId, :find_snippets_by_user_id

        parameter :page

        response 200 do
          key :description, 'Snippets of the user specified by its ID'
          schema type: :array do
            items do
              key :'$ref', :SnippetOutput
            end
          end
        end

        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError
      end

      operation :post do
        key :description, "Creates the specified user's snippet"
        key :operationId, :create_snippet

        parameter :snippet

        response 201 do
          key :description, 'Created snippet'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end
    end

    swagger_path '/snippets' do
      operation :get do
        key :description, 'Returns all snippets'
        key :operationId, :get_all_snippets

        parameter :page

        response 200 do
          key :description, 'All snippets'
          schema type: :array do
            items do
              key :'$ref', :SnippetOutput
            end
          end
        end

        extend Swagger::ErrorResponses::UnexpectedError
      end
    end
  end
end
