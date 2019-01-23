module Api
 module V1
  class HmiReasonsController < ApplicationController

  before_action :set_hmi_reason, only: [:show, :update, :destroy]

  # GET /hmi_reasons
  def index
    @hmi_reasons = HmiReason.all

    render json: @hmi_reasons
  end

  # GET /hmi_reasons/1
  def show
    render json: @hmi_reason
  end

  # POST /hmi_reasons
  def create
    @hmi_reason = HmiReason.new(hmi_reason_params)

    if @hmi_reason.save
      render json: @hmi_reason, status: :created, location: @hmi_reason
    else
      render json: @hmi_reason.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hmi_reasons/1
  def update
    if @hmi_reason.update(hmi_reason_params)
      render json: @hmi_reason
    else
      render json: @hmi_reason.errors, status: :unprocessable_entity
    end
  end

  # DELETE /hmi_reasons/1
  def destroy
    @hmi_reason.destroy
  end

  def operator_machine
    
    operator = OperatorMappingAllocation.where(operator_id:params[:operator_id],date:Date.today)
   render json: operator
  end


  def hmi_machine_reason_create
     params.permit!
     duration= Time.at(params[:end_time].to_time.to_i - params[:start_time].to_time.to_i).utc.strftime("%H:%M:%S")
     data=HmiMachineReason.create(start_time: params[:start_time], end_time: params[:end_time], duration: duration, hmi_machine_detail_id: params[:hmi_machine_detail_id],hmi_reason_id: params[:hmi_reason_id], machine_id: params[:machine_id], tenant_id: params[:tenant_id])
     render json: data
  end 

  def hmi_job_program
     params.permit!
    data=HmiMachineDetail.create(job_id: params["job_id"], program_number: params["program_number"], parts_count: params["parts_count"], operator_id: params["operator_id"], machine_id: params["machine_id"], tenant_id: params["tenant_id"])
   render json: data
  end  
  

  

   def hmi_reason_chart
    tenant=Tenant.find(params[:tenant_id])
    machines=params[:machine_id] == "undefined" ? tenant.machines.ids : Machine.where(id:params[:machine_id]).ids
    shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
    data = HmiMachineDetail.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
    data2 = data.group_by{|d| d[:description]}
    reason = []
    time = []
    data2.map do |key2,value2|
      reason << key2
      time << value2.pluck(:duration).sum
    end
    shift_number = shifts.first
    machine_name = Machine.find(machines).first.machine_name
    render json: {reason: reason, time: time, shift: shift_number, machine_name: machine_name, date: params["start_date"] }
  end







  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hmi_reason
      @hmi_reason = HmiReason.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def hmi_reason_params
      params.require(:hmi_reason).permit(:name, :image_path, :is_active)
    end
  end

end
end
