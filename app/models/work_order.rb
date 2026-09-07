class WorkOrder < ApplicationRecord
  belongs_to :part
  has_many :operations, -> { order(:position) }, dependent: :destroy

  enum :status, {
    scheduled: 0,
    active: 1,
    completed: 2,
    cancelled: 3
  }

  scope :overdue, -> {
    where("due_on < ?", Date.current)
      .where.not(status: [ :completed, :cancelled ])
  }

  validates :number, presence: true, uniqueness: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :due_on, presence: true

  validate :operations_must_be_completed, if: :completed?

  def overdue?
    due_on < Date.current && !completed? && !cancelled?
  end

  private

  def operations_must_be_completed
    if operations.empty?
      errors.add(
        :status,
        "cannot be completed without operations"
      )
    elsif operations.where.not(status: :completed).exists?
      errors.add(
        :status,
        "cannot be completed while operations remain unfinished"
      )
    end
  end
end
