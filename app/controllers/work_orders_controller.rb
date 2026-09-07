class WorkOrdersController < ApplicationController
  before_action :set_work_order, only: %i[show edit update destroy]

  def index
    @work_orders = WorkOrder.includes(:part).order(:due_on)
  end

  def show
  end

  def new
    @work_order = WorkOrder.new
  end

  def create
    @work_order = WorkOrder.new(work_order_params)

    if @work_order.save
      redirect_to @work_order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @work_order.update(work_order_params)
      redirect_to @work_order
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work_order.destroy
    redirect_to work_orders_path
  end

  private

  def set_work_order
    @work_order = WorkOrder.find(params[:id])
  end

  def work_order_params
    params.expect(
      work_order: [
        :number,
        :part_id,
        :quantity,
        :due_on,
        :status,
        :notes
      ]
    )
  end
end
