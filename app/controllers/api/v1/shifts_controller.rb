module Api
  module V1
 class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :update, :destroy]

  # GET /shifts
  def index
    @shifts = Tenant.find(params[:tenant_id]).shift
   # @shifts= @shifts.nil? ? 0 : @shifts 
    render json: @shifts
  end

  # GET /shifts/1
  def show
    render json: @shift
  end

  # POST /shifts
  def create
    #working_time = shift_params[:working_time].to_time.strftime("%I:%M %S")
    #day_start_time = shift_params[:day_start_time].to_time.strftime("%I:%M %P")
    @shift = Shift.new(shift_params)


    if @shift.save
      render json: @shift, status: :created#, location: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifts/1
  def update
 #   shift_params[:working_time] = shift_params[:working_time].to_time.strftime("%I:%M %S")
  #  shift_params[:day_start_time] = shift_params[:day_start_time].to_time.strftime("%I:%M %P")
    if @shift.update(shift_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifts/1
  def destroy
    @shift.destroy
    if @shift.destroy
      render json: true
    else
      render json: false
    end
  end

  def shift_validation
    shift = Tenant.find(params[:tenant_id]).shift
    render json:  shift
  end

  def shift_detail
    shift_count = Shift.find(params[:shift_id]).no_of_shift
    render json: shift_count
  end

  def all_shifts
    shifts=Shift.get_all_shift(params)
    render json: shifts
  end

  

    def current_shift
    tenant = Tenant.find(params[:tenant_id])
    machine = tenant.machines.first.id
    shift = Shifttransaction.current_shift(tenant.id)
    if shift.shift_no == 1
       shift_no = tenant.shift.shifttransactions.last.shift_no
       date = Date.yesterday.strftime("%Y-%m-%d")
       shifttransactions = tenant.shift.shifttransactions.where(shift_no: shift_no).first
     else
       shift_no = shift.shift_no - 1
       date = Date.today
       shifttransactions = tenant.shift.shifttransactions.where(shift_no: shift_no).first
     end
   render json: {shift_no: shift_no, shift_id: shifttransactions.id, date: date, machine: machine, tenant: tenant.id}
  end






  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shift_params
      params.require(:shift).permit!
   end
end
end
end
