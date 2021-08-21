module ResponseConcern
  extend ActiveSupport::Concern

  # Exceptions
  class RecordNotFoundException < Exception; end
  class InvalidSessionException < Exception; end

  included do
    # Rescues
    rescue_from RecordNotFoundException, with: :record_not_found
    rescue_from InvalidSessionException, with: :unauthorized
  end

  def render_errors(object)
    render json: { messages: object.errors }, status: :bad_request
  end

  def record_not_found
    render json: { message: 'Record not found.' }, status: :bad_request
  end

  def unauthorized
    render json: { message: 'User is not authorized.' }, status: :unauthorized
  end
end
