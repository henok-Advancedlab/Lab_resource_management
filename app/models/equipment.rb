class Equipment < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A[A-Z]{3}-\d{3}\z/, message: "must be in the format XXX-NNN" }
  validates :status, presence: true
  validates :category, presence: true
end
