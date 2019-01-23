module Api
  module V1
class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]
#  skip_before_action :authenticate_request, only: %i[toradax_test]

  # GET /roles
  def index
   # @roles = Tenant.find(params[:tenant_id]).roles.where.not(role_name:"CEO")
    @roles = Role.where.not(role_name:"CEO")
    render json: @roles
  end

  def role_detail
    role = Role.find(params[:role_id])
    render json: role
  end

  # GET /roles/1
  def show
    render json: @role
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role, status: :created#, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
  end

  def toradax_test1
    mac = Machine.find_by_machine_ip(params["machine_ip"])
    tenant = mac.tenant
    date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.current_shift(tenant.id)    
    #shift = Shifttransaction.find(6)
    case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = Date.today.strftime("%Y-%m-%d")  
      when shift.day == 1 && shift.end_day == 2
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
          date = (Date.today - 1.day).strftime("%Y-%m-%d")
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
          date = Date.today.strftime("%Y-%m-%d")
        end    
      when shift.day == 2 && shift.end_day == 2
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")      
      end


    if shift.operator_allocations.where(machine_id:mac.id).last.nil?
        operator_id = nil
      else
        if shift.operator_allocations.where(machine_id:mac.id).present?
        shift.operator_allocations.where(machine_id:mac.id).each do |ro| 
          aa = ro.from_date
          bb = ro.to_date
          cc = date
          if cc.to_date.between?(aa.to_date,bb.to_date)  
          dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
          if dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.present?
            dd.operator_mapping_allocations.where(:date=>date.to_date).last.update(reason: params["Reasons"])
            operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id 
          else
            operator_id = nil
          end              
          end
        end
        else
        operator_id = nil
        end
      end
  end



   def toradax_test
   #params["data"].split(":").last
    machine = Machine.find_by_machine_ip(params["ip"])
   machine.machine_setting.update(reason: params['Reasons'])
    tenant = machine.tenant
    date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.current_shift(tenant.id)    
    #shift = Shifttransaction.find(6)
    case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = Date.today.strftime("%Y-%m-%d")  
      when shift.day == 1 && shift.end_day == 2
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
          date = (Date.today - 1.day).strftime("%Y-%m-%d")
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
          date = Date.today.strftime("%Y-%m-%d")
        end    
      when shift.day == 2 && shift.end_day == 2
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")      
      end
      machine_log = machine.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
      parts_count = Machine.new_parsts_count(machine_log) 
      if shift.operator_allocations.where(machine_id:machine.id).last.nil?
       #byebug
        operator_id = nil
        #render json: {data: "data"}
      else
        if shift.operator_allocations.where(machine_id:machine.id).present?
          shift.operator_allocations.where(machine_id:machine.id).each do |ro| 
            aa = ro.from_date
            bb = ro.to_date
            cc = date
            if cc.to_date.between?(aa.to_date,bb.to_date)  
              dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
              data = dd.operator_mapping_allocations.where(:date=>date.to_date).last
              if data.operator.present?
                if params["Reasons"] != nil
                  data.update(reason: params["Reasons"])
                end
                val = dd.operator_mapping_allocations.where(:date=>date.to_date).pluck(:rejected,:rework,:approved).last.sum
                if parts_count > val
                  if params["data"]!=nil
                    if params["data"].split(":").first == "approved"
                      approved = params["data"].split(":").last == nil ?  0 : params["data"].split(":").last.to_i
                      data.update(approved: approved + data.approved )
                    elsif params["data"].split(":").first == "rejected"
                      rejected = params["data"].split(":").last == nil ?  0 : params["data"].split(":").last.to_i
                      data.update(rejected: rejected + data.rejected )
                    elsif params["data"].split(":").first == "rework"
                      rework = params["data"].split(":").last == nil ?  0 : params["data"].split(":").last.to_i
                      data.update(rework: rework + data.rework )
                    end
                  end
                end
                operator_id = data.operator.id 
              else
                operator_id = nil
              end              
            end
          end
        else
          operator_id = nil
        end
        #render json: {data: "data"}
      end
      
      render json: {data: "data"}
    end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:role_name, :tenant_id)
    end
end
end
end
