module Swagger::UserApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks
    include Swagger::ErrorSchema

    swagger_path '/users' do
      operation :post do
        key :description, 'Creates a user'
        key :operationId, :create_user

        parameter :user

        response 201 do
          key :description, 'Created user'
          schema do
            key :'$ref', :UserOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::UnexpectedError
      end
    end

    swagger_path '/users/{id}' do
      parameter :user_id do
        key :name, :id
      end

      operation :get do
        key :description, 'Finds the specified user'
        key :operationId, :find_user_by_id

        response 200 do
          key :description, 'User specified by its ID'
          schema do
            key :'$ref', :UserOutput
          end
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError
      end

      operation :patch do
        key :description, 'Updates the user'
        key :operationId, :update_user

        parameter :user

        response 200 do
          key :description, 'Updated user'
          schema do
            key :'$ref', :UserOutput
          end
        end

        extend Swagger::ErrorResponses::InvalidParameterError
        extend Swagger::ErrorResponses::NotFoundError
        extend Swagger::ErrorResponses::UnexpectedError

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes the user'
        key :operationId, :delete_user

        response 204 do
          key :description, 'The user was deleted'
        end

        extend Swagger::ErrorResponses::UnauthorizedError
        extend Swagger::ErrorResponses::NotFoundError

        security api_key: []
      end
    end
  end
end
