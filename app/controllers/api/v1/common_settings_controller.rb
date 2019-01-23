module Api
  module V1

class CommonSettingsController < ApplicationController
  before_action :set_common_setting, only: [:show, :update, :destroy]

  # GET /common_settings
  def index
    @common_settings = CommonSetting.all
    render json: @common_settings
  end

  # GET /common_settings/1
  def show
    render json: @common_setting
  end

  # POST /common_settings
  def create
    @common_setting = CommonSetting.new(common_setting_params)


    if @common_setting.save
       
      case
        when @common_setting.setting_id == 1
          Tenant.all.each do |i|
            if TenantSettingList.create(setting_name: i.setting_name, tenant_setting_id: tenant_setting.id).present?
        TenantSettingList.create(setting_name: i.setting_name, tenant_setting_id: tenant_setting.id)
      end
          end
          
        when @common_setting.setting_id == 2

        when @common_setting.setting_id == 3
      end





      render json: @common_setting, status: :created, location: @common_setting
    else
      render json: @common_setting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /common_settings/1
  def update
    if @common_setting.update(common_setting_params)
      render json: @common_setting
    else
      render json: @common_setting.errors, status: :unprocessable_entity
    end
  end

  # DELETE /common_settings/1
  def destroy
    @common_setting.destroy
    Tenant.all.each do |ten|
      sett_list = ten.tenant_setting.tenant_setting_lists.where(setting_name: @common_setting.setting_name)
      sett_list.delete_all
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_common_setting
      @common_setting = CommonSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def common_setting_params
      params.require(:common_setting).permit(:setting_name, :setting_id)
    end
end
end
end
