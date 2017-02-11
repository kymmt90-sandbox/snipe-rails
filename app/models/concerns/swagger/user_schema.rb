module Swagger::UserSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :User do
      key :required, [:id, :name, :email, :password]
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :email do
        key :type, :string
      end
      property :password do
        key :type, :string
        key :format, :password
      end
    end
  end
end
