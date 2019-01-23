module Api
  module V1
class OeeCalculationsController < ApplicationController
  before_action :set_oee_calculation, only: [:show, :update, :destroy]

  # GET /oee_calculations
  def index
   #    @oee_calculations = OeeCalculation.all
   @oee_calculations = OeeCalculation.includes(:machine).where(machines: {tenant_id:params[:tenant_id]}).reverse
    render json: @oee_calculations
  end

  # GET /oee_calculations/1
  def show
    render json: @oee_calculation
  end

  # POST /oee_calculations
  def create
    
    
   unless OeeCalculation.where(date: params[:date], shifttransaction_id: params[:shifttransaction_id], machine_id: params[:machine_id]).present?
    @oee_calculation = OeeCalculation.new(oee_calculation_params)

    if @oee_calculation.save
      
      params["prog_count"].each do |ii|
        OeeCalculateList.create(program_number: ii["programe_number"], run_rate: ii["idle_run_rate"], parts_count: ii["count"], time: ii["time"], oee_calculation_id: @oee_calculation.id)
      end

      render json: @oee_calculation#, status: :created, location: @oee_calculation
    else
      render json: @oee_calculation.errors, status: :unprocessable_entity
    end
  else
    render json: 'Not Created'
  end
  end

  def oee_create
    
  end

  # PATCH/PUT /oee_calculations/1
  def update
    if @oee_calculation.update(oee_calculation_params)
      render json: @oee_calculation
    else
      render json: @oee_calculation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /oee_calculations/1
  def destroy
    @oee_calculation.destroy
  end

  def calculate_time
    date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.find(params[:shift_id])
     case
        when shift.day == 1 && shift.end_day == 1   
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time  
        when shift.day == 1 && shift.end_day == 2
          if Time.now.strftime("%p") == "AM"
            start_time = (date+" "+shift.shift_start_time).to_time-1.day
            end_time = (date+" "+shift.shift_end_time).to_time
          else
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time+1.day
          end
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time     
        end


    time = end_time - start_time
    duration = time/60
    prod_time = duration - 30
    balance = prod_time
    render json: {duration: duration, prod_time: prod_time, balance: balance }
  end


    def shift_part_cal
    data = ShiftPart.where(date: params[:date], shifttransaction_id: params[:shift_id], machine_id: params[:machine_id])
    render json: data
  end

  def shift_part_creation
    shift_no = Shifttransaction.find(params[:shift_id]).shift_no
    data = ShiftPart.create(date: params[:date], shift_no: shift_no, part: params[:part], program_number: params[:program_number], shifttransaction_id: params[:shift_id], machine_id: params[:machine_id])
    render json: data
  end

  def delete_shift_part
    data = ShiftPart.find(params[:id]).delete
    render json: true
  end

  def shift_part_update
    data = ShiftPart.find(params[:id])#.update(status: params[:status])
    data.update(status: params[:status])
    render json: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oee_calculation
      @oee_calculation = OeeCalculation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def oee_calculation_params
      params.require(:oee_calculation).permit(:duration, :break_time, :balance, :date, :machine_id, :shifttransaction_id, :prod_time)
    end
end
end
end
