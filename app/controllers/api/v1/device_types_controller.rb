 module Api
  module V1 
class DeviceTypesController < ApplicationController
  before_action :set_device_type, only: [:show, :update, :destroy]

  # GET /device_types
  def index
    @device_types = DeviceType.all

    render json: @device_types
  end

  # GET /device_types/1
  def show
    render json: @device_type
  end

  # POST /device_types
  def create
    @device_type = DeviceType.new(device_type_params)

    if @device_type.save
      render json: @device_type, status: :created
    else
      render json: @device_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /device_types/1
  def update
    if @device_type.update(device_type_params)
      render json: @device_type
    else
      render json: @device_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /device_types/1
  def destroy
    @device_type.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device_type
      @device_type = DeviceType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def device_type_params
      params.require(:device_type).permit(:name, :count, :per_pic_price, :total_price, :purchase_date, :created_by, :updated_by, :deleted_at)
    end
end
end
end
