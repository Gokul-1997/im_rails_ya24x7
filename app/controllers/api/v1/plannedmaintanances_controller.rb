module Api
  module V1
class PlannedmaintanancesController < ApplicationController
  before_action :set_plannedmaintanance, only: [:show, :update, :destroy]

  # GET /plannedmaintanances
  def index
    @plannedmaintanances = Plannedmaintanance.all

    render json: @plannedmaintanances
  end

  # GET /plannedmaintanances/1
  def show
    render json: @plannedmaintanance
  end

  # POST /plannedmaintanances
  def create
    @plannedmaintanance = Plannedmaintanance.new(plannedmaintanance_params)

    if @plannedmaintanance.save
      render json: @plannedmaintanance, status: :created, location: @plannedmaintanance
    else
      render json: @plannedmaintanance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plannedmaintanances/1
  def update
    if @plannedmaintanance.update(plannedmaintanance_params)
      render json: @plannedmaintanance
    else
      render json: @plannedmaintanance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /plannedmaintanances/1
  def destroy
    @plannedmaintanance.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plannedmaintanance
      @plannedmaintanance = Plannedmaintanance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def plannedmaintanance_params
      params.require(:plannedmaintanance).permit(:maintanance_type, :duration_from, :duration_to, :expire_date, :supplier_name, :remarks, :machine_id, :tenant_id)
    end
end
end
end