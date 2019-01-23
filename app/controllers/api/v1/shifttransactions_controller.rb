module Api
  module V1
class ShifttransactionsController < ApplicationController
  before_action :set_shifttransaction, only: [:show, :update, :destroy]

  # GET /shifttransactions
  def index
    @shifttransactions = Shift.find(params[:shift_id]).shifttransactions
    render json: @shifttransactions
  end

  # GET /shifttransactions/1
  def show
    render json: @shifttransaction
  end

  # POST /shifttransactions
  def create
    @shifttransaction = Shifttransaction.new(shifttransaction_params)
    @shifttransaction.actual_working_hours =params[:shift_start_time].to_time.strftime("%p")=="PM" && params[:shift_end_time].to_time.strftime("%p")=="AM" ?  Time.at((params[:shift_end_time].to_time - 1.day) - params[:shift_start_time].to_time).utc.strftime("%H:%M:%S") : Time.at(params[:shift_end_time].to_time - params[:shift_start_time].to_time).utc.strftime("%H:%M:%S") 
    @shifttransaction.actual_working_without_break = @shifttransaction.actual_working_hours
    if @shifttransaction.save
      render json: @shifttransaction, status: :created#, location: @shifttransaction
    else
      render json: @shifttransaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifttransactions/1
  def update
     
    if @shifttransaction.update(shifttransaction_params)
      actual_working_hours =params[:shift_start_time].to_time.strftime("%p")=="PM" && params[:shift_end_time].to_time.strftime("%p")=="AM" ?  Time.at((params[:shift_end_time].to_time - 1.day) - params[:shift_start_time].to_time).utc.strftime("%H:%M:%S") : Time.at(params[:shift_end_time].to_time - params[:shift_start_time].to_time).utc.strftime("%H:%M:%S") 
      @shifttransaction.update(actual_working_hours:actual_working_hours)
      render json: @shifttransaction
    else
      render json: @shifttransaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifttransactions/1
  def destroy
    @shifttransaction.destroy
    if @shifttransaction.destroy
      render json: true
    else
      render json: false
    end
    #@shifttransaction.update(isactive:0)
  end

  def get_all_shift
    shift = Shifttransaction.get_all_shift(params)
    render json: shift
  end

  def find_shift
    data = Shifttransaction.find_shift(params)
    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shifttransaction
      @shifttransaction = Shifttransaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shifttransaction_params
      params.require(:shifttransaction).permit!
    end
end
end
end
