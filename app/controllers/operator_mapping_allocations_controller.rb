class OperatorMappingAllocationsController < ApplicationController
  before_action :set_operator_mapping_allocation, only: [:show, :update, :destroy]

  # GET /operator_mapping_allocations
  def index
    @operator_mapping_allocations = OperatorMappingAllocation.all

    render json: @operator_mapping_allocations
  end

  # GET /operator_mapping_allocations/1
  def show
    render json: @operator_mapping_allocation
  end

  # POST /operator_mapping_allocations
  def create
    @operator_mapping_allocation = OperatorMappingAllocation.new(operator_mapping_allocation_params)

    if @operator_mapping_allocation.save
      render json: @operator_mapping_allocation, status: :created, location: @operator_mapping_allocation
    else
      render json: @operator_mapping_allocation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operator_mapping_allocations/1
  def update
    if @operator_mapping_allocation.update(operator_mapping_allocation_params)
      render json: @operator_mapping_allocation
    else
      render json: @operator_mapping_allocation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /operator_mapping_allocations/1
  def destroy
    @operator_mapping_allocation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator_mapping_allocation
      @operator_mapping_allocation = OperatorMappingAllocation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operator_mapping_allocation_params
      params.fetch(:operator_mapping_allocation, {})
    end
end
