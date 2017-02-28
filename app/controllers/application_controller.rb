class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from ActiveRecord::RecordNotFound do |e|
    response = {
      errors: [
        "#{e.model} not found"
      ]
    }
    render json: response, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :bad_request
  end
end
