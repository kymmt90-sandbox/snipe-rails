module Swagger::UserApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/users' do
      operation :post do
        key :description, 'Creates a user'
        key :operationId, 'createUser'

        parameter do
          key :name, :user
          key :in, :body
          key :description, 'The created user'
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end

        response 201 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end
      end
    end

    swagger_path '/users/{id}' do
      operation :get do
        key :description, 'Returns a user'
        key :operationId, 'findUserById'

        parameter do
          key :name, :id
          key :in, :path
          key :description, 'User ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 200 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end
      end

      operation :patch do
        key :description, 'Updates a user'
        key :operationId, 'updateUser'

        parameter do
          key :name, :id
          key :in, :path
          key :description, 'User ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        parameter do
          key :name, :user
          key :in, :body
          key :description, 'The updated user attributes'
          key :required, true
          schema do
            key :'$ref', :User
          end
        end

        response 200 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes a user'
        key :operationId, 'deleteUser'

        parameter do
          key :name, :id
          key :in, :path
          key :description, 'User ID'
          key :required, true
          key :type, :integer
          key :format, :int64
        end

        response 204 do
          key :description, 'no content'
        end

        security api_key: []
      end
    end
  end
end
