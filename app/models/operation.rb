class Operation < ApplicationRecord
  belongs_to :work_order

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2
  }

  validates :name, presence: true
  validates :position, numericality: { greater_than: 0 }

  before_save :set_completed_at

  private

  def set_completed_at
    if completed?
      self.completed_at ||= Time.current
    else
      self.completed_at = nil
    end
  end
end
