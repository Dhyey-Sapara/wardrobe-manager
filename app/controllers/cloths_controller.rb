class ClothsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cloth, only: [ :show, :edit, :update, :destroy ]

  def index
    cloths = current_user.cloths
                         .search(params[:query])
                         .by_color(params[:color])
                         .includes(:location, image_attachment: :blob)
    cloths = cloths.where(cloth_type: params[:cloth_type]) if params[:cloth_type].present?
    cloths = cloths.where(location_id: params[:location_id]) if params[:location_id].present?
    cloths = cloths.order(created_at: :desc)

    @colors = current_user.cloths.distinct.pluck(:color).compact
    @locations = current_user.locations.order(:name)
    @pagy, @cloths = pagy(cloths, limit: 12)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    fresh_when @cloth, public: false
  end

  def new
    @cloth = current_user.cloths.build
    @locations = current_user.locations.order(:name)
  end

  def edit
    @locations = current_user.locations.order(:name)
  end

  def create
    @cloth = current_user.cloths.build(cloth_params)

    if @cloth.save
      redirect_to @cloth, notice: "Cloth added successfully."
    else
      @locations = current_user.locations.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @cloth.update(cloth_params)
      redirect_to @cloth, notice: "Cloth updated successfully."
    else
      @locations = current_user.locations.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cloth.destroy
    redirect_to cloths_url, notice: "Cloth removed."
  end

  private

  def set_cloth
    @cloth = current_user.cloths.find(params[:id])
  end

  def cloth_params
    params.require(:cloth).permit(:name, :description, :location_id, :color, :company, :cloth_type, :image)
  end
end
