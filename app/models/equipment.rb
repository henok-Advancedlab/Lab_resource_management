class Equipment < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 3 }, format: { with: /\A(?=.*[a-zA-Z]).*\z/m, message: "must contain at least one letter" }
  validates :serial_number, presence: true, uniqueness: true, format: { with: /\A[A-Z]{3}-\d{3}\z/, message: "must be in the format XXX-NNN" }
  validates :status, presence: true, inclusion: { in: %w[available in_use maintenance], message: "%{value} is not a valid status" }
  # `belongs_to :category` is required by default, so a separate presence validation
  # would only produce a duplicate "can't be blank" error alongside "must exist".
end
