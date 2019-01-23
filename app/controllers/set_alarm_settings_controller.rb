class SetAlarmSettingsController < ApplicationController
  before_action :set_set_alarm_setting, only: [:show, :update, :destroy]

  # GET /set_alarm_settings
  def index
    @set_alarm_settings = SetAlarmSetting.all

    render json: @set_alarm_settings
  end

  # GET /set_alarm_settings/1
  def show
    render json: @set_alarm_setting
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_set_alarm_setting
      @set_alarm_setting = SetAlarmSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def set_alarm_setting_params
      params.require(:set_alarm_setting).permit(:alarm_for, :time_interval, :alarm_type, :machine_id)
    end
end
