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
    end

    SWAGGERED_CLASSES = [
      User,
      self
    ].freeze
  end

  def root_json
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
