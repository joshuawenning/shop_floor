class DashboardController < ApplicationController
  def show
    @scheduled_count = WorkOrder.scheduled.count
    @active_count = WorkOrder.active.count
    @overdue_count = WorkOrder.overdue.count

    @work_orders = WorkOrder
      .includes(:part)
      .where(status: [ :scheduled, :active ])
      .order(:due_on)
  end
end
