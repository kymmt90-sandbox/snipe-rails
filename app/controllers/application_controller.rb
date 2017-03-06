class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from Exception do |e|
    log_error_backtrace(e)
    head :internal_server_error
  end

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

  def not_found
    response_body = {
      errors: [
        "#{request.url} does not exist"
      ]
    }
    render json: response_body, status: :not_found
  end

  def validation_errors(model)
    response = { errors: [] }
    model.errors.messages.each do |attribute, details|
      details.each do |detail|
        response[:errors] << "#{attribute} #{detail}"
      end
    end
    response
  end

  private

  def log_error_backtrace(e)
    Rails.logger.error(e)
    e.backtrace.each do |line|
      Rails.logger.error(line)
    end
  end
end
