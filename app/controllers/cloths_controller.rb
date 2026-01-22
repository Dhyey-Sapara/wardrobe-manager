class ClothsController < ApplicationController
  before_action :set_cloth, only: [ :show, :edit, :update, :destroy ]

  def index
    @cloths = Cloth.all
                   .search(params[:query])
                   .by_color(params[:color])
    @cloths = @cloths.where(cloth_type: params[:cloth_type]) if params[:cloth_type].present?
    @cloths = @cloths.where(location: params[:location]) if params[:location].present?
    @cloths = @cloths.order(created_at: :desc)
    @colors = Cloth.distinct.pluck(:color).compact
  end

  def show
  end

  def new
    @cloth = Cloth.new
  end

  def edit
  end

  def create
    @cloth = Cloth.new(cloth_params)

    if @cloth.save
      redirect_to @cloth, notice: "Cloth added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @cloth.update(cloth_params)
      redirect_to @cloth, notice: "Cloth updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cloth.destroy
    redirect_to cloths_url, notice: "Cloth removed."
  end

  private

  def set_cloth
    @cloth = Cloth.find(params[:id])
  end

  def cloth_params
    params.require(:cloth).permit(:name, :description, :location, :color, :company, :type, :image)
  end
end
