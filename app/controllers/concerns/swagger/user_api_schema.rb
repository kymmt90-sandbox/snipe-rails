module Swagger::UserApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

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

      operation :post do
        key :description, 'Creates a user'
        key :operationId, 'createUser'

        parameter do
          key :name, :name
          key :in, :query
          key :description, 'User name'
          key :required, true
          key :type, :string
        end
        parameter do
          key :name, :email
          key :in, :query
          key :description, 'User email address'
          key :required, true
          key :type, :string
        end
        parameter do
          key :name, :password
          key :in, :query
          key :description, 'User password'
          key :required, true
          key :type, :string
          key :format, :password
        end

        response 201 do
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
          key :name, :name
          key :in, :query
          key :description, 'User name'
          key :type, :string
        end
        parameter do
          key :name, :email
          key :in, :query
          key :description, 'User email address'
          key :type, :string
        end
        parameter do
          key :name, :password
          key :in, :query
          key :description, 'User password'
          key :type, :string
          key :format, :password
        end

        response 200 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end
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
      end
    end
  end
end
