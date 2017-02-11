class ApidocsController < ApplicationController
  include Swagger::RootSchema

  def index
    render json: root_json
  end
end
