class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [ :edit, :update, :destroy ]

  def index
    @locations = current_user.locations.order(:name)
  end

  def new
    @location = current_user.locations.build
  end

  def create
    @location = current_user.locations.build(location_params)
    if @location.save
      redirect_to locations_path, notice: "Location added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "Location updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path, notice: "Location removed."
  end

  private

  def set_location
    @location = current_user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end
end
