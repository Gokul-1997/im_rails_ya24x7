class OperatorAllocationsController < ApplicationController
  before_action :set_operator_allocation, only: [:show, :update, :destroy]

  # GET /operator_allocations
  def index
    @operator_allocations = OperatorAllocation.all

    render json: @operator_allocations
  end

  # GET /operator_allocations/1
  def show
    render json: @operator_allocation
  end

  # POST /operator_allocations
  def create
    @operator_allocation = OperatorAllocation.new(operator_allocation_params)

    if @operator_allocation.save
      render json: @operator_allocation, status: :created, location: @operator_allocation
    else
      render json: @operator_allocation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operator_allocations/1
  def update
    if @operator_allocation.update(operator_allocation_params)
      render json: @operator_allocation
    else
      render json: @operator_allocation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /operator_allocations/1
  def destroy
    @operator_allocation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator_allocation
      @operator_allocation = OperatorAllocation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operator_allocation_params
      params.require(:operator_allocation).permit(:operator_id, :shifttransaction_id, :machine_id, :description)
    end
end
