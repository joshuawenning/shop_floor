class Part < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :inventory_quantity,
    numericality: { greater_than_or_equal_to: 0 }
end
