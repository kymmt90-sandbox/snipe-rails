module Swagger::StarApiSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/snippets/{snippet_id}/star' do
      parameter do
        key :name, :snippet_id
        key :in, :path
        key :description, 'Snippet ID'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      operation :get do
        key :description, 'Check the snippet is starred'

        response 204 do
          key :description, 'The snippet is starred when the API returns no content'
        end

        response 401 do
          key :description, 'unauthorized user'
          schema do
            key :'$ref', :ErrorOutput
          end
        end

        response 404 do
          key :description, 'The snippet is **not** starred when the API returns no content / snippet not found'
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

        security api_token: []
      end

      operation :put do
        key :description, 'Star the snippet'

        response 204 do
          key :description, 'The snippet has been starred when the API returns no content'
        end

        response 401 do
          key :description, 'unauthorized user'
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

        security api_token: []
      end

      operation :delete do
        key :description, 'Unstar the snippet'

        response 204 do
          key :description, 'The snippet has been unstarred when the API returns no content'
        end

        response 401 do
          key :description, 'unauthorized user'
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

        security api_token: []
      end
    end
  end
end
