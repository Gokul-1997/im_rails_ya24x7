class CncoperationsController < ApplicationController
  before_action :set_cncoperation, only: [:show, :update, :destroy]

  # GET /cncoperations
  def index
    @cncoperations = Cncoperation.all

    render json: @cncoperations
  end

  # GET /cncoperations/1
  def show
    render json: @cncoperation
  end

  # POST /cncoperations
  def create
    @cncoperation = Cncoperation.new(cncoperation_params)

    if @cncoperation.save
      render json: @cncoperation, status: :created# location: @cncoperation
    else
      render json: @cncoperation.errors, status: :unprocessable_entity
    end
  end

   
  # PATCH/PUT /cncoperations/1
  def update
    if @cncoperation.update(cncoperation_params)
      render json: @cncoperation
    else
      render json: @cncoperation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cncoperations/1
  def destroy
    @cncoperation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncoperation
      @cncoperation = Cncoperation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncoperation_params
      params.require(:cncoperation).permit(:operation_name, :description, :plan_status, :cncjob_id, :tenant_id)
    end
end
