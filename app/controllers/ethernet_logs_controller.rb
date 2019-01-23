class EthernetLogsController < ApplicationController
  before_action :set_ethernet_log, only: [:show, :update, :destroy]

  # GET /ethernet_logs
  def index
    @ethernet_logs = EthernetLog.all

    render json: @ethernet_logs
  end

  # GET /ethernet_logs/1
  def show
    render json: @ethernet_log
  end

  # POST /ethernet_logs
  def create
    @ethernet_log = EthernetLog.new(ethernet_log_params)

    if @ethernet_log.save
      render json: @ethernet_log, status: :created, location: @ethernet_log
    else
      render json: @ethernet_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ethernet_logs/1
  def update
    if @ethernet_log.update(ethernet_log_params)
      render json: @ethernet_log
    else
      render json: @ethernet_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ethernet_logs/1
  def destroy
    @ethernet_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ethernet_log
      @ethernet_log = EthernetLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ethernet_log_params
      params.require(:ethernet_log).permit(:date, :status, :machine_id)
    end
end
