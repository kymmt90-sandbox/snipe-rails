module Swagger::SnippetApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Snippet ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      operation :get do
        key :description, 'Returns a snippet'
        key :operationId, 'findSnippetById'

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
        key :description, 'Updates a snippet'
        key :operationId, 'updateSnippet'

        parameter do
          key :name, :snippet
          key :in, :body
          key :description, 'The updated snippet'
          key :required, true
          schema do
            key :'$ref', :Snippet
          end
        end

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
        key :description, 'Deletes a snippet'
        key :operationId, 'deleteSnippet'

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
      parameter do
        key :name, :user_id
        key :in, :path
        key :description, 'User ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      operation :get do
        key :description, "Returns a specified user's snippets"
        key :operationId, 'findSnippetsByUserId'

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
        key :description, "Creates a specified user's snippet"
        key :operationId, 'createSnippet'

        parameter do
          key :name, :snippet
          key :in, :body
          key :description, 'The created snippet'
          key :required, true
          schema do
            key :'$ref', :SnippetInput
          end
        end

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
        key :description, "Returns snippets"
        key :operationId, 'findSnippets'

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
