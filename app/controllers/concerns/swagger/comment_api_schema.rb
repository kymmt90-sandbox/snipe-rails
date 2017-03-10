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
          key :description, 'The comments response'
          schema type: :array do
            items do
              key :'$ref', :CommentOutput
            end
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

      operation :post do
        key :description, 'Creates a comment'
        key :operationId, :create_snippet

        parameter :comment

        response 201 do
          key :description, 'The created comment response'
          schema do
            key :'$ref', :CommentOutput
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
    end

    swagger_path '/comments/{id}' do
      parameter :comment_id do
        key :name, :id
      end

      operation :get do
        key :description, "Returns the specified comment"
        key :operationId, :find_comment_by_id

        response 200 do
          key :description, 'The comment response'
          schema do
            key :'$ref', :CommentOutput
          end
        end

        response 404 do
          key :description, 'comment not found'
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
        key :description, 'Updates the comment'
        key :operationId, :update_comment

        parameter :comment

        response 201 do
          key :description, 'The updated comment response'
          schema do
            key :'$ref', :CommentOutput
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
          key :description, 'comment not found'
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
        key :description, 'Deletes the comment'
        key :operationId, :delete_comment

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
          key :description, 'comment not found'
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
  end
end
