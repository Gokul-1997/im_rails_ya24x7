module Api
  module V1
class CncvendorsController < ApplicationController
  before_action :set_cncvendor, only: [:show, :update, :destroy]

  # GET /cncvendors
  def index
    @cncvendors = Cncvendor.all

    render json: @cncvendors
  end

  # GET /cncvendors/1
  def show
    render json: @cncvendor
  end

  # POST /cncvendors
  def create
    @cncvendor = Cncvendor.new(cncvendor_params)

    if @cncvendor.save
      render json: @cncvendor, status: :created, location: @cncvendor
    else
      render json: @cncvendor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cncvendors/1
  def update
    if @cncvendor.update(cncvendor_params)
      render json: @cncvendor
    else
      render json: @cncvendor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cncvendors/1
  def destroy
    @cncvendor.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncvendor
      @cncvendor = Cncvendor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncvendor_params
      params.require(:cncvendor).permit(:vendor_name, :start_date, :delivery_date, :quantity, :phone_number, :email_id, :cncoperation_id, :tenant_id)
    end
end
end
end