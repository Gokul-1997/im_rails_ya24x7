 module Api
  module V1
class OperatorMappingAllocationsController < ApplicationController
  before_action :set_operator_mapping_allocation, only: [:show, :update, :destroy]

  # GET /operator_mapping_allocations
  def index
    shift = Shifttransaction.current_shift(params[:tenant_id])
    #@operator_mapping_allocations = OperatorMappingAllocation.where(operator_id:Tenant.find(params[:tenant_id]).operators.ids).where(:date=>Date.today)
    @operator_mapping_allocations = OperatorMappingAllocation.includes(:operator_allocation).where(operator_allocations: {tenant_id:params[:tenant_id],shifttransaction_id:shift.id}).where(:date=>Date.today)
    render json: @operator_mapping_allocations,status: :ok
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
      params.require(:operator_mapping_allocation).permit(:date,:operator_id,:operator_allocation_id,:target)
    end
end
end
end
