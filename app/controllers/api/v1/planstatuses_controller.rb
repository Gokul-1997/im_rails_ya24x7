module Api
  module V1
class PlanstatusesController < ApplicationController
  before_action :set_planstatus, only: [:show, :update, :destroy]

  # GET /planstatuses
  def index
    @planstatuses = Planstatus.all

    render json: @planstatuses
  end

  # GET /planstatuses/1
  def show
    render json: @planstatus
  end

  # POST /planstatuses
  def create
    @planstatus = Planstatus.new(planstatus_params)

    if @planstatus.save
      render json: @planstatus, status: :created, location: @planstatus
    else
      render json: @planstatus.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /planstatuses/1
  def update
    if @planstatus.update(planstatus_params)
      render json: @planstatus
    else
      render json: @planstatus.errors, status: :unprocessable_entity
    end
  end

  # DELETE /planstatuses/1
  def destroy
    @planstatus.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planstatus
      @planstatus = Planstatus.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def planstatus_params
      params.require(:planstatus).permit(:planstatus_name, :description)
    end
end
end
end