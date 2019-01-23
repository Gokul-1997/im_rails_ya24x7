class MaintananceentriesController < ApplicationController
  before_action :set_maintananceentry, only: [:show, :update, :destroy]

  # GET /maintananceentries
  def index
    @maintananceentries = Maintananceentry.all

    render json: @maintananceentries
  end

  # GET /maintananceentries/1
  def show
    render json: @maintananceentry
  end

  # POST /maintananceentries
  def create
    @maintananceentry = Maintananceentry.new(maintananceentry_params)

    if @maintananceentry.save
      render json: @maintananceentry, status: :created, location: @maintananceentry
    else
      render json: @maintananceentry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /maintananceentries/1
  def update
    if @maintananceentry.update(maintananceentry_params)
      render json: @maintananceentry
    else
      render json: @maintananceentry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /maintananceentries/1
  def destroy
    @maintananceentry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintananceentry
      @maintananceentry = Maintananceentry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def maintananceentry_params
      params.require(:maintananceentry).permit(:maintanance_type, :maintanance_date, :service_engineer_name, :maintanance_time, :remarks, :machine_id, :tenant_id)
    end
end
