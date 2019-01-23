 module Api
  module V1 
class AlarmHistoriesController < ApplicationController

  before_action :set_alarm_history, only: [:show, :update, :destroy]
 # skip_before_action :authenticate_request, only: %i[create alarm_last_history]
  # GET /alarm_histories
  def index
     @alarm_histories = AlarmTest.includes(:machine).where(machines: {tenant_id:params[:tenant_id]}).reverse#.order(:time)
    render json: @alarm_histories
  end

  # GET /alarm_histories/1
  def show
    render json: @alarm_history
  end

  # POST /alarm_histories
  def create
      mac = Machine.find_by_machine_ip(params[:machine_id])
      date = Alarmtest.pluck(:time)
    if mac.alarm_histories.present? && mac.alarm_histories.where(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message]).last.present?
      mac_alarm = mac.alarm_histories.where(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message]).last
      if (mac_alarm.message == params[:message]) && (mac_alarm.alarm_status == 1) && (mac_alarm.alarm_type == params[:alarm_type]) && (mac_alarm.alarm_no == params[:alarm_no]) && (mac_alarm.axis_no == params[:axis_no]) && (params[:alarm_status] != "1")    
        mac_alarm.update(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no],alarm_status:params[:alarm_status],updated_at:Time.now)
      elsif (mac_alarm.message == params[:message]) && (mac_alarm.alarm_status != 1) && (params[:alarm_status] == "1") && (mac_alarm.time != params[:time]) 
        AlarmHistory.create(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message], alarm_status:params[:alarm_status], machine_id:mac.id)
      else
        puts "no Alarm Found"
      end
    elsif params[:alarm_status] == "1"
      AlarmHistory.create(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message], alarm_status:params[:alarm_status], machine_id:mac.id)
    else
      puts "no no"
    end
  end


def alarm_last_history # Last 50
  mac = Machine.find_by_machine_ip(params[:machine_id])
  if mac.alarm_tests.where(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message]).last.present?
    puts "Old Alarms"
  else
    AlarmTest.create(alarm_type: params[:alarm_type], alarm_no: params[:alarm_no], axis_no: params[:axis_no], time: params[:time], message:params[:message], alarm_status:params[:alarm_status], machine_id:mac.id)
  end  
end

 #  {"alarm_type"=>"12341", "alarm_no"=>"49", "axis_no"=>"2", "time"=>"2018-7-17 9:28:39", "message"=>"  OVERTRAVEL ( SOFT 1 )", "machine_id"=>"192.168.11.30", "alarm_status"=>"0"} 
 #{"alarm_type"=>"12341", "alarm_no"=>"48", "axis_no"=>"0", "time"=>"2018-7-17 14:35:23", "message"=>" EMERGENCY STOP", "machine_id"=>"192.168.11.10", "alarm_status"=>"0"}

  # PATCH/PUT /alarm_histories/1
  def update
    if @alarm_history.update(alarm_history_params)
      render json: @alarm_history
    else
      render json: @alarm_history.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarm_histories/1
  def destroy
    @alarm_history.destroy
  end

  def report
   alarm_history = AlarmHistory.alarm_histories_report(params)
   render json: alarm_history.flatten
 end

 def alarm_automatic
   @alarm_histories = AlarmTest.includes(:machine).where(machines: {tenant_id:params[:tenant_id]},category:  "Automatic").reverse#.order(:time)
    render json: @alarm_histories
 end

def alarm_manual
   @alarm_histories = AlarmTest.includes(:machine).where(machines: {tenant_id:params[:tenant_id]},category: "Manual").reverse#.order(:time)
    render json: @alarm_histories
 end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alarm_history
      @alarm_history = AlarmHistory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarm_history_params
      params.require(:alarm_history).permit(:alarm_type, :alarm_no, :axis_no, :time, :message, :alarm_status, :machine_id)
    end
end
end
end
