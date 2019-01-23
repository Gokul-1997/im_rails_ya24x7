class CtMachineLogsController < ApplicationController
  before_action :set_ct_machine_log, only: [:show, :update, :destroy]

  # GET /ct_machine_logs
  def index
    @ct_machine_logs = CtMachineLog.all

    render json: @ct_machine_logs
  end

  # GET /ct_machine_logs/1
  def show
    render json: @ct_machine_log
  end

  # POST /ct_machine_logs
  def create
    @ct_machine_log = CtMachineLog.new(ct_machine_log_params)

    if @ct_machine_log.save
      render json: @ct_machine_log, status: :created, location: @ct_machine_log
    else
      render json: @ct_machine_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ct_machine_logs/1
  def update
    if @ct_machine_log.update(ct_machine_log_params)
      render json: @ct_machine_log
    else
      render json: @ct_machine_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ct_machine_logs/1
  def destroy
    @ct_machine_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ct_machine_log
      @ct_machine_log = CtMachineLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ct_machine_log_params
      params.require(:ct_machine_log).permit(:status, :heart_beat, :from_date, :to_date, :uptime, :reason, :machine_id)
    end
end
