class MaintenanceRecord < ApplicationRecord
  # Associations
  belongs_to :equipment

  # Validations
  # `belongs_to :equipment` is required by default, so a separate presence
  # validation would only duplicate the "must exist" error.
  validates :performed_at, presence: true
  validates :description, presence: true

  validate :performed_at_not_in_future

  private

  def performed_at_not_in_future
    if performed_at.present? && performed_at > Time.current
      errors.add(:performed_at, "cannot be in the future")
    end
  end
end
