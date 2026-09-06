class PartsController < ApplicationController
  def index
    @parts = Part.order(:number)
  end

  def show
    @part = Part.find(params[:id])
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

  private

  def part_params
    params.expect(part: [ :number, :name, :revision, :inventory_quantity ])
  end
end
