class Category < ApplicationRecord
  # Associations
  has_many :equipment, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
end
