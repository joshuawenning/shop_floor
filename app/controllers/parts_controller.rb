class PartsController < ApplicationController
  def index
    @parts = Part.order(:number)
  end

  def show
    @part = Part.find(params[:id])
  end
end
