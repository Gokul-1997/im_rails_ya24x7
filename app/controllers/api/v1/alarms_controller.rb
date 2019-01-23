module Api
  module V1
class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:show, :update, :destroy]

  # GET /alarms
  def index
    #@alarms = Alarm.limit(40).where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).distinct(:alarm_message).order("created_at DESC").select("DISTINCT on (alarm_message) *")
   # @alarms = Alarm.uniq_data(params[:tenant_id])#Alarm.limit(20).where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).distinct(:alarm_message).order("created_at DESC")
   @alarms = Alarm.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).distinct(:alarm_message).order("updated_at DESC").where('updated_at > ?', 3.days.ago)
   #@alarms =Alarm.includes(:machine).where(machines: {tenant_id:params[:tenant_id]}).distinct(:alarm_message).order("updated_at DESC").where('updated_at > ?', 3.days.ago)
#@alarms = Alarm.all
    render json: @alarms
  end

  def alarm_dashboard
    #Alarm.includes(:machine).where(machines: {tenant_id:params[:tenant_id]})
     #@alarm = Alarm.where(:machine_id=>Tenant.find(params[:tenant_id]).machines.ids).uniq.last(6)
     @alarm = Alarm.includes(:machine).where(machines: {tenant_id:params[:tenant_id]}).distinct.last(6)
     render json:@alarm
  end
  #def alarm_tenant
  #  @alarm= Alarm.where(machine_id: Tenant.find(params[:tenant_id]).machines)
  #  render json: @alarm
 # end

 def report
 alarms = Alarm.alarm_report(params)
 render json: alarms.flatten
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
    Alarm.where(alarm_message:@alarm.alarm_message,machine_id:@alarm.machine_id).delete_all
    #@alarm.destroy
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
end
end
