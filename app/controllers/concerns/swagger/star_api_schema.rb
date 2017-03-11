module Swagger::StarApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{snippet_id}/star' do
      parameter :snippet_id do
        key :name, :snippet_id
      end

      operation :get do
        key :description, 'Check whether the authorized user starred the snippet or not'
        key :operationId, :check_snippet_starred

        response 204 do
          key :description, 'The snippet is starred'
        end

        response 404 do
          key :description, 'The snippet is **not** starred when the response body is empty, otherwise resource was not found'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_token: []
      end

      operation :put do
        key :description, 'Star the snippet'
        key :operationId, :star_snippet

        response 204 do
          key :description, 'The snippet has been starred'
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_token: []
      end

      operation :delete do
        key :description, 'Unstar the snippet'
        key :operationId, :unstar_snippet

        response 204 do
          key :description, 'The snippet has been unstarred'
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_token: []
      end
    end
  end
end
