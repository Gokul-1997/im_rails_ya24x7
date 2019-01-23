module Api
  module V1
class EthernetLogsController < ApplicationController
  before_action :set_ethernet_log, only: [:show, :update, :destroy]
#  skip_before_action :authenticate_request, only: %i[create]

  # GET /ethernet_logs
  def index
    @ethernet_logs = EthernetLog.where(tenant_id:params[:tenant_id]).where.not(status: 2).last(10)
    render json: @ethernet_logs
  end

  # GET /ethernet_logs/1
  def show
    render json: @ethernet_log
  end

  # POST /ethernet_logs
  def create
    machine = Machine.find_by_machine_ip(params[:machine_id])
    @ethernet_log = EthernetLog.new(status: params[:status],machine_id: machine.id,date: params[:date],tenant_id: machine.tenant_id)

    if @ethernet_log.save
      response = { message: 'created successfully'}
      render json: response, status: :created
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
      params.require(:ethernet_log).permit(:date, :status, :machine_id,:tenant_id)
    end
end
end
end
