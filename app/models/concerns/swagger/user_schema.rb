module Swagger::UserSchema
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :User do
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

    swagger_schema :UserInput do
      allOf do
        schema do
          key '$ref', :User
        end
        schema do
          key :required, [:name, :email, :password]
        end
      end
    end

    swagger_schema :UserOutput do
      key :required, [:id, :name]
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
    end
  end
end
