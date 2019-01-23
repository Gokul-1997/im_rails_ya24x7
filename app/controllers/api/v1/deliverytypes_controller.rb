module Api
  module V1
class DeliverytypesController < ApplicationController
  before_action :set_deliverytype, only: [:show, :update, :destroy]

  # GET /deliverytypes
  def index
    @deliverytypes = Deliverytype.all

    render json: @deliverytypes
  end

  # GET /deliverytypes/1
  def show
    render json: @deliverytype
  end

  # POST /deliverytypes
  def create
    @deliverytype = Deliverytype.new(deliverytype_params)

    if @deliverytype.save
      render json: @deliverytype, status: :created, location: @deliverytype
    else
      render json: @deliverytype.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /deliverytypes/1
  def update
    if @deliverytype.update(deliverytype_params)
      render json: @deliverytype
    else
      render json: @deliverytype.errors, status: :unprocessable_entity
    end
  end

  # DELETE /deliverytypes/1
  def destroy
    @deliverytype.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deliverytype
      @deliverytype = Deliverytype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def deliverytype_params
      params.require(:deliverytype).permit(:deliverytype_name, :description)
    end
end
end
end