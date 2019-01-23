class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:show, :update, :destroy]

  # GET /alarms
  def index
    @alarms = Alarm.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids)

    render json: @alarms
  end

  def alarm_history
    @alarms =params[:date].present? ? Alarm.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).where(created_at:params[:date]..params[:date]).with_deleted : Alarm.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).where(created_at:Date.today..Date.today).with_deleted

    render json: @alarms
  end

  # GET /alarms/1
  def show
    render json: @alarm
  end

  # POST /alarms
  def create
    @alarm = Alarm.new(alarm_params)

    if @alarm.save
      render json: @alarm, status: :created, location: @alarm
    else
      render json: @alarm.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alarms/1
  def update
    if @alarm.update(alarm_params)
      render json: @alarm
    else
      render json: @alarm.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarms/1
  def destroy
    @alarm.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alarm
      @alarm = Alarm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarm_params
      params.require(:alarm).permit(:alarm_type, :alarm_number, :alarm_message, :emergency, :machine_id)
    end
end
