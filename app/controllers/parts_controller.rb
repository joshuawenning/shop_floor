class PartsController < ApplicationController
  before_action :set_part, only: %i[show edit update destroy]

  def index
    @parts = Part.order(:number)
  end

  def show
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)

    if @part.save
      redirect_to @part
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @part.update(part_params)
      redirect_to @part
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @part.destroy

    redirect_to parts_path
  end

  private

  def part_params
    params.expect(part: [ :number, :name, :revision, :inventory_quantity ])
  end
end
