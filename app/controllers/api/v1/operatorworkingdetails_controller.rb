module Api
  module V1
class OperatorworkingdetailsController < ApplicationController
  before_action :set_operatorworkingdetail, only: [:show, :update, :destroy]

  # GET /operatorworkingdetails
  def index
    @operatorworkingdetails = Operatorworkingdetail.all

    render json: @operatorworkingdetails
  end

  # GET /operatorworkingdetails/1
  def show
    render json: @operatorworkingdetail
  end

  # POST /operatorworkingdetails
  def create
    @operatorworkingdetail = Operatorworkingdetail.new(operatorworkingdetail_params)
    from_time = operatorworkingdetail_params[:from_time].split("-").first
    to_time = operatorworkingdetail_params[:from_time].split("-").last
    if @operatorworkingdetail.save
      @operatorworkingdetail.update(from_time:from_time,to_time:to_time)
      render json: @operatorworkingdetail, status: :created#, location: @operatorworkingdetail
    else
      render json: @operatorworkingdetail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operatorworkingdetails/1
  def update
    if @operatorworkingdetail.update(operatorworkingdetail_params)
      render json: @operatorworkingdetail
    else
      render json: @operatorworkingdetail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /operatorworkingdetails/1
  def destroy
    @operatorworkingdetail.destroy
    #@operatorworkingdetail.update(isactive:0)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operatorworkingdetail
      @operatorworkingdetail = Operatorworkingdetail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operatorworkingdetail_params
      params.require(:operatorworkingdetail).permit!#(:working_date, :from_time, :to_time, :user_id, :shifttransaction_id, :machine_id, :tenant_id)
    end
end
end
end