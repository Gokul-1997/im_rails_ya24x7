class ConnectionLogsController < ApplicationController
  before_action :set_connection_log, only: [:show, :update, :destroy]

  # GET /connection_logs
  def index
    @connection_logs = ConnectionLog.where(:created_at=>Date.toady)

    render json: @connection_logs
  end

  # GET /connection_logs/1
  def show
    render json: @connection_log
  end

  # POST /connection_logs
  def create
    
    @connection_log = ConnectionLog.new(connection_log_params)

    if @connection_log.save
      render json: @connection_log, status: :created, location: @connection_log
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
