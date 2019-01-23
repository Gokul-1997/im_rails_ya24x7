  module Api
  module V1
class ConnectionLogsController < ApplicationController
  before_action :set_connection_log, only: [:show, :update, :destroy]
 # skip_before_action :authenticate_request, only: %i[create]

  # GET /connection_logs
  def index

    @connection_logs = ConnectionLog.where(tenant_id:params[:tenant_id]).last(10)#.where(:created_at=>Date.toady)

    render json: @connection_logs
  end

  # GET /connection_logs/1
  def show
    render json: @connection_log
  end

  # POST /connection_logs
  def create
     #date=(params[:date]).strftime("%d-%m-%Y %I:%M %p")
 #  mac=Machine.find_by_machine_ip(params[:machine_id])
 
    @connection_log = ConnectionLog.new(status: params[:status],tenant_id: params[:tenant_id],date: params[:date])
    if @connection_log.save
        response = { message: 'created successfully'}
      render json: response, status: :created
    else
      render json: @connection_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /connection_logs/1
  def update
    if @connection_log.update(connection_log_params)
      render json: @connection_log
    else
      render json: @connection_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /connection_logs/1
  def destroy
    @connection_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection_log
      @connection_log = ConnectionLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def connection_log_params
      params.require(:connection_log).permit(:date, :status, :tenant_id)
    end
end
end
end
