  module Api
  module V1
class TenantsController < ApplicationController
  before_action :set_tenant, only: [:show, :update, :destroy]
 # skip_before_action :authenticate_request,:only => [:tenant_user_creation]

  # GET /tenants
  def index
      tenants = Tenant.where(isactive:true)
      render json: tenants
  end

  # GET /tenants/1
  def show
    render json: @tenant
  end
  

   def send_enquery_mail
  #EnqueryTestMailer.enquiry_to(params).deliver_now
  #EnqueryTestMailer.enquery_from(params).deliver_now
  #MailLog.create(:from=>,:to=>)
  render json: true
 end
 
  # POST /tenants
  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      render json: @tenant, status: :created#, location: @tenant
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tenants/1
  def update
    if @tenant.update(tenant_params)
      render json: @tenant
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tenants/1
  def destroy
   @tenant.destroy
   #@tenant.update(isactive:0)
  end
   
   def get_all_notification
    notification = Notification.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids)
    render json: notification
   end

  def tenant_user_creation  
    tenant = Tenant.new(tenant_name: params[:tenant_name], address_line1: params[:address_line1], address_line2: params[:address_line1], city: params[:city], state: params[:state], country: params[:country], pincode: params[:pincode],  companytype_id:params[:companytype_id],isactive: false)
    tenant.save!
    role = Role.create(role_name:"CEO", tenant_id:tenant.id)
    role1 = Role.create(role_name:"Operator", tenant_id:tenant.id)
    user = User.new(first_name: params[:first_name], last_name: params[:last_name], email_id: params[:email_id], password: params[:password], phone_number: params[:phone_number], remarks: params[:remarks], usertype_id: params[:usertype_id], tenant_id:tenant.id, role_id:role.id, default: params[:default])   
    data = UserSetting.create(user_id: user.id)
    tenant_setting = TenantSetting.create(tenant_id: tenant.id)

    if CommonSetting.where(setting_id: 1).present?
      CommonSetting.where(setting_id: 1).each do |i|
        if TenantSettingList.where(setting_name: i.setting_name, tenant_setting_id: tenant_setting.id).present?
        TenantSettingList.create(setting_name: i.setting_name, tenant_setting_id: tenant_setting.id)
      end
      end
    end


    if user.save!
      #UserMailer.sample_email(user).deliver
     render json: true
    else
      render json: false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tenant_params
      params.require(:tenant).permit(:tenant_name, :address_line1, :address_line2, :city, :state, :country, :pincode, :parent_tenant_id, :companytype_id,:isactive)
    end
end
end
end
