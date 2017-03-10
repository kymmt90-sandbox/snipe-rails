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
      key :description, 'User attributes'
      key :required, true
      schema do
        key :'$ref', :UserInput
      end
    end

    base.parameter :snippet_id do
      key :name, :id
      key :in, :path
      key :description, 'Snippet ID'
      key :required, true
      key :type, :integer
      key :format, :int64
    end

    base.parameter :snippet do
      key :name, :snippet
      key :in, :body
      key :description, 'Snippet attributes'
      key :required, true
      schema do
        key :'$ref', :Snippet
      end
    end
  end
end
