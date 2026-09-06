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

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])

    if @part.update(part_params)
      redirect_to @part
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @part = Part.find(params[:id])
    @part.destroy

    redirect_to parts_path
  end

  private

  def part_params
    params.expect(part: [ :number, :name, :revision, :inventory_quantity ])
  end
end
