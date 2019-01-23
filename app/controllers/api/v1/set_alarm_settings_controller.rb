module Api
  module V1
class SetAlarmSettingsController < ApplicationController
  before_action :set_set_alarm_setting, only: [:show, :update, :destroy]

  # GET /set_alarm_settings
  def index
    @set_alarm_settings = SetAlarmSetting.includes(:machine).where(machines: {tenant_id:params[:tenant_id]})

    render json: @set_alarm_settings
  end

  # GET /set_alarm_settings/1
  def show
    render json: @set_alarm_setting
  end

  
  
  def set_status 
    #status = SetAlarmSetting.includes(:machine).find(id:params[:id],machines: {tenant_id:params[:tenant_id]}).update(active:params[:set_alarm_setting][:active])
    status=SetAlarmSetting.find_by_id(params[:set_alarm_setting][:id]).update(active:params[:set_alarm_setting][:active])
    render json: status
  end

  # POST /set_alarm_settings
  def create
    @set_alarm_setting = SetAlarmSetting.new(set_alarm_setting_params)

    if @set_alarm_setting.save
      render json: @set_alarm_setting, status: :created, location: @set_alarm_setting
    else
      render json: @set_alarm_setting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /set_alarm_settings/1
  def update
    
    if @set_alarm_setting.update(set_alarm_setting_params)
      render json: @set_alarm_setting
    else
      render json: @set_alarm_setting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /set_alarm_settings/1
  def destroy
    @set_alarm_setting.destroy
  end

  def pre_setting_dasboard
    data1 = SetAlarmSetting.pre_setting_dasboard(params)
    running_count = []
    ff = {}
   data1.group_by{|d| d[:unit]}.map do |key1,value1|
     value={}
     value1.group_by{|i| i[:machine_status]}.map do |k,v|
      k = "waste"  if k == nil
      k = "stop"  if k == 100
      k = "running"  if k == 3
      k = "idle"  if k == 0 
      k = "idle1" if k == 1
      value[k] = v.count
     end

     
     ff[key1] = value
   end
   render json: {"data" => data1.group_by{|d| d[:unit]}, count: ff}
  end

  def pre_setting_dasboard_full_data
    data1 = SetAlarmSetting.pre_setting_dasboard_full_data(params)
    running_count = []
    ff = {}
      
   data1.group_by{|d| d[:unit]}.map do |key1,value1|
     value={}
     
     value1.group_by{|i| i[:machine_status]}.map do |k,v|
     # byebug
      k = "waste"  if k == nil
      k = "stop"  if k == 100
      k = "running"  if k == 3
      k = "idle"  if k == 0 
      k = "idle1" if k == 1
      value[k] = v.count
     end

    
     ff[key1] = value
   end

  #----------------------#
  # fff = []
  #  data1.group_by{|d| d[:unit]}.map do |key1,value1|

  #  @run = []
  #  @idle = []
  #  @stop = []
  #  @waste = []

  #   value1.each do |i|
  #     if i[:machine_status] == 3
  #       @run << 1
  #     elsif i[:machine_status] == 100
  #       @stop << 1
  #     elsif i[:machine_status] == ''
  #       @waste << 1
  #     else
  #       @idle << 1
  #     end    
  #   end
  #   byebug
  #   fff << {key1: {:running=>2, :idle=>2, :stop=>0, :waste=>0}}
    
  #  end

  # byebug

   render json: {"data" => data1.group_by{|d| d[:unit]}, count: ff}
  end

  def single_machine_pre_data
    data = SetAlarmSetting.single_machine_pre_data(params)
    render json: data
  end


  def hmi_reson
   data = HourReport.hmi_reports(params)
   #time = Time.at(data.pluck(:duration).sum).utc.strftime("%H:%M:%S")
   render json: data# {data: data, time: time} 
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_set_alarm_setting
      @set_alarm_setting = SetAlarmSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def set_alarm_setting_params
      params.require(:set_alarm_setting).permit(:alarm_for, :time_interval, :alarm_type, :machine_id,:active)
    end
end
end
end
