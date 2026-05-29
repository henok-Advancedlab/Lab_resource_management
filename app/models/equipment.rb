class Equipment < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy
  
  # Validations
  validates :name, presence: true, length: { minimum: 3 }, format: { with: /[a-zA-Z]/, message: "must contain at least one letter" }
  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A[A-Z]{3}-\d{3}\z/, message: "must be in the format XXX-NNN" }
  validates :status, presence: true
  validates :category, presence: true
end
