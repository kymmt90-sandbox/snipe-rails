module Swagger::RootSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Snipe'
        key :description, 'A Gist clone'
        contact do
          key :name, '@kymmt90'
        end
        license do
          key :name, 'MIT'
        end
      end
      key :basePath, '/'
      key :consumes, ['application/json']
      key :produces, ['application/json']

      security_definition :api_key do
        key :type, :apiKey
        key :name, 'Authorization'
        key :in, :header
      end

      extend Swagger::Parameters
    end

    swagger_path '/user_token' do
      operation :post do
        key :description, 'Create JWT'
        key :operationId, 'create_jwt'

        parameter :credential

        response 201 do
          key :description, 'JWT'
          schema do
            key :required, [:jwt]
            property :jwt do
              key :type, :string
            end
          end
        end
      end
    end

    SWAGGERED_CLASSES = [
      User,
      UsersController,
      Snippet,
      SnippetsController,
      Comment,
      CommentsController,
      StarsController,
      self
    ].freeze
  end

  def root_json
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
