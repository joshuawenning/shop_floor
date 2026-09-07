class Operation < ApplicationRecord
  belongs_to :work_order

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2
  }

  validates :name, presence: true
  validates :position, numericality: { greater_than: 0 }
end
