class OperatorproductiondetailsController < ApplicationController
  before_action :set_operatorproductiondetail, only: [:show, :update, :destroy]

  # GET /operatorproductiondetails
  def index
    @operatorproductiondetails = Operatorproductiondetail.all

    render json: @operatorproductiondetails
  end

  # GET /operatorproductiondetails/1
  def show
    render json: @operatorproductiondetail
  end

  # POST /operatorproductiondetails
  def create
    @operatorproductiondetail = Operatorproductiondetail.new(operatorproductiondetail_params)

    if @operatorproductiondetail.save
      render json: @operatorproductiondetail, status: :created, location: @operatorproductiondetail
    else
      render json: @operatorproductiondetail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operatorproductiondetails/1
  def update
    if @operatorproductiondetail.update(operatorproductiondetail_params)
      render json: @operatorproductiondetail
    else
      render json: @operatorproductiondetail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /operatorproductiondetails/1
  def destroy
    @operatorproductiondetail.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operatorproductiondetail
      @operatorproductiondetail = Operatorproductiondetail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operatorproductiondetail_params
      params.require(:operatorproductiondetail).permit(:no_of_rejects, :no_of_parts_produced, :parts_moved_to_next_operation, :total_down_time, :reason_for_down_time, :last_machine_reset_time, :remarks, :operatorworkingdetail_id, :tenant_id)
    end
end
