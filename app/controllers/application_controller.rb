class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from ActiveRecord::RecordNotFound do |e|
    response_body = {
      errors: [
        "#{e.model} not found"
      ]
    }
    render json: response_body, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |e|
    response_body = {
      errors: [
        'Required parameters are missing'
      ]
    }
    render json: response_body, status: :bad_request
  end
end
