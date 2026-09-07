class WorkOrder < ApplicationRecord
  belongs_to :part
  has_many :operations, -> { order(:position) }, dependent: :destroy

  enum :status, {
    scheduled: 0,
    active: 1,
    completed: 2,
    cancelled: 3
  }

  validates :number, presence: true, uniqueness: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :due_on, presence: true

  def overdue?
    due_on < Date.current && !completed? && !cancelled?
  end
end
