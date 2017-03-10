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
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end

        response 400 do
          key :description, 'parameters are invalid'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response :default do
          key :description, 'unexpected error'
          schema do
            key :'$ref', :ErrorOutput
          end
        end
      end
    end

    swagger_path '/users/{id}' do
      parameter :user_id do
        key :name, :id
      end

      operation :get do
        key :description, 'Returns the specified user'
        key :operationId, :find_user_by_id

        response 200 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end

        response 404 do
          key :description, 'user not found'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response :default do
          key :description, 'unexpected error'
          schema do
            key :'$ref', :ErrorOutput
          end
        end
      end

      operation :patch do
        key :description, 'Updates the user'
        key :operationId, :update_user

        parameter :user

        response 200 do
          key :description, 'user response'
          schema do
            key :'$ref', :UserOutput
          end
        end

        response 400 do
          key :description, 'parameters are invalid'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response 401 do
          key :description, 'unauthorized user'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response 404 do
          key :description, 'user not found'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response :default do
          key :description, 'unexpected error'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        security api_key: []
      end

      operation :delete do
        key :description, 'Deletes the user'
        key :operationId, :delete_user

        response 204 do
          key :description, 'no content'
        end

        response 401 do
          key :description, 'unauthorized user'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response 404 do
          key :description, 'user not found'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        security api_key: []
      end
    end
  end
end
