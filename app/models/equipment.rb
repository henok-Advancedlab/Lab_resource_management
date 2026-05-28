class Equipment < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :status, presence: true
  validates :category, presence: true
end
