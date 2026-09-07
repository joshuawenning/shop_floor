class OperationsController < ApplicationController
  before_action :set_work_order
  before_action :set_operation, only: %i[show edit update destroy]

  def show
  end

  def new
    @operation = @work_order.operations.new
  end

  def create
    @operation = @work_order.operations.new(operation_params)

    if @operation.save
      redirect_to @work_order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @operation.update(operation_params)
      redirect_to @work_order
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @operation.destroy
    redirect_to @work_order
  end

  private

  def set_work_order
    @work_order = WorkOrder.find(params[:work_order_id])
  end

  def set_operation
    @operation = @work_order.operations.find(params[:id])
  end

  def operation_params
    params.expect(
      operation: [
        :name,
        :position,
        :status
      ]
    )
  end
end
