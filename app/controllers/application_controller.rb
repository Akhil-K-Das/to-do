class ApplicationController < ActionController::API
  before_action :set_workspace
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from StandardError, with: :internal_server_error

  private

  def set_workspace
    @current_workspace = request.env['current_workspace']
    render json: { error: 'Workspace not found' }, status: :not_found unless @current_workspace
  end
  
  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def internal_server_error(exception)
    render json: { error: "Something went wrong. Please try again." }, status: :internal_server_error
  end
end
