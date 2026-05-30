class ApplicationController < ActionController::Base
  # Skip CSRF token enforcement for external JSON clients (like curl).
  protect_from_forgery with: :null_session

  # Globally rescue common database errors and format them as clean JSON responses.
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  private

  # 404 — resource-specific message, e.g. { "error": "Category not found" }
  def render_not_found(exception)
    model = exception.model || "Record"
    render json: { error: "#{model} not found" }, status: :not_found
  end

  # 422 — array of readable validation messages, e.g. { "errors": ["Name can't be blank"] }
  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
