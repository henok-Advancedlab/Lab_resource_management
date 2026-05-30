class ApplicationController < ActionController::Base
  # 1. Skip CSRF token authenticity enforcement for external JSON clients (like curl)
  protect_from_forgery with: :null_session

  # 2. Globally rescue common database errors and format them as clean JSON responses
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  private

  # Helper to catch missing record lookups (returns HTTP 404)
  def render_not_found(exception)
    render json: { 
      error: "Resource not found", 
      details: exception.message 
    }, status: :not_found
  end

  # Helper to catch failed model validations (returns HTTP 422)
  def render_unprocessable_entity(exception)
    render json: { 
      errors: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end
end