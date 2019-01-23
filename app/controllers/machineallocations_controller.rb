class MachineallocationsController < ApplicationController
  before_action :set_machineallocation, only: [:show, :update, :destroy]

  # GET /machineallocations
  def index
    @machineallocations = Machineallocation.all

    render json: @machineallocations
  end

  # GET /machineallocations/1
  def show
    render json: @machineallocation
  end

  # POST /machineallocations
  def create
    @machineallocation = Machineallocation.new(machineallocation_params)

    if @machineallocation.save
      render json: @machineallocation, status: :created, location: @machineallocation
    else
      render json: @machineallocation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /machineallocations/1
  def update
    if @machineallocation.update(machineallocation_params)
      render json: @machineallocation
    else
      render json: @machineallocation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /machineallocations/1
  def destroy
    @machineallocation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machineallocation
      @machineallocation = Machineallocation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def machineallocation_params
      params.require(:machineallocation).permit(:from_date, :to_date, :start_time, :end_time, :actual_quantity, :cycle_time, :idle_cycle_time, :total_down_time, :produced_quantiy, :tenant_id, :machine_id, :cncoperation_id)
    end
end
