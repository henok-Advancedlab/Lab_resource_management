class MaintenanceRecord < ApplicationRecord
  # Associations
  belongs_to :equipment
  
  # Validations
  validates :equipment, presence: true
  validates :performed_at, presence: true
  validates :description, presence: true
end
