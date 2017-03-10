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
          key :description, 'The snippet response'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        response 404 do
          key :description, 'snippet not found'
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
        key :description, 'Updates the snippet'
        key :operationId, :update_snippet

        parameter :snippet

        response 200 do
          key :description, 'The updated snippet response'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        response 400 do
          key :description, 'invalid parameters'
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
          key :description, 'snippet not found'
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
        key :description, 'Deletes the snippet'
        key :operationId, :delete_snippet

        response 204 do
          key :description, 'No content'
        end

        response 401 do
          key :description, 'unauthorized user'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response 404 do
          key :description, 'snippet not found'
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
    end

    swagger_path '/users/{user_id}/snippets' do
      parameter :user_id do
        key :name, :user_id
      end

      operation :get do
        key :description, "Returns the specified user's snippets"
        key :operationId, :find_snippets_by_user_id

        response 200 do
          key :description, 'The snippets response'
          schema type: :array do
            items do
              key :'$ref', :SnippetOutput
            end
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

      operation :post do
        key :description, "Creates the specified user's snippet"
        key :operationId, :create_snippet

        parameter :snippet

        response 201 do
          key :description, 'The created snippet'
          schema do
            key :'$ref', :SnippetOutput
          end
        end

        response 400 do
          key :description, 'invalid parameters'
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
    end

    swagger_path '/snippets' do
      operation :get do
        key :description, 'Returns all snippets'
        key :operationId, :get_all_snippets

        response 200 do
          key :description, 'The snippets response'
          schema type: :array do
            items do
              key :'$ref', :SnippetOutput
            end
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
  end
end
