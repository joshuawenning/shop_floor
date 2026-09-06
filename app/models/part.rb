class Part < ApplicationRecord
  has_many :work_orders, dependent: :restrict_with_error
  
  validates :number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :inventory_quantity,
    numericality: { greater_than_or_equal_to: 0 }
end
