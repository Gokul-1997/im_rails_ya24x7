class BreakTimesController < ApplicationController
  before_action :set_break_time, only: [:show, :update, :destroy]

  # GET /break_times
  def index
    @break_times = BreakTime.all

    render json: @break_times
  end

  # GET /break_times/1
  def show
    render json: @break_time
  end

  # POST /break_times
  def create
    @break_time = BreakTime.new(break_time_params)

    if @break_time.save
      render json: @break_time, status: :created, location: @break_time
    else
      render json: @break_time.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /break_times/1
  def update
    if @break_time.update(break_time_params)
      render json: @break_time
    else
      render json: @break_time.errors, status: :unprocessable_entity
    end
  end

  # DELETE /break_times/1
  def destroy
    @break_time.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_break_time
      @break_time = BreakTime.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def break_time_params
      params.require(:break_time).permit(:reasion, :start_time, :end_time, :total_minutes, :shifttransaction_id)
    end
end
