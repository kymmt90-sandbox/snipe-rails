module Swagger::Parameters
  def self.extended(base)
    base.parameter :user_id do
      key :name, :id
      key :in, :path
      key :description, 'User ID'
      key :required, true
      key :type, :integer
      key :format, :int64
    end

    base.parameter :user do
      key :name, :user
      key :in, :body
      key :description, 'The user to create'
      key :required, true
      schema do
        key :'$ref', :UserInput
      end
    end
  end
end
