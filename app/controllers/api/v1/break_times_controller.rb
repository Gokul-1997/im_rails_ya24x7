module Api
  module V1
class BreakTimesController < ApplicationController
  before_action :set_breaktime, only: [:show, :update, :destroy]

  # GET /breaktimes
  def index

    @breaktimes = Shifttransaction.find(params[:shifttransaction_id]).break_times

    render json: @breaktimes
  end

  # GET /breaktimes/1
  def show
    render json: @breaktime
  end

  # POST /breaktimes
  def create
    @breaktime = BreakTime.new(breaktime_params)

    if @breaktime.save
      diff = (@breaktime.end_time.to_time - @breaktime.start_time.to_time)/60
      diff = diff.round()
      @breaktime.update(total_minutes:diff)
      render json: @breaktime, status: :created, location: @breaktime
    else
      render json: @breaktime.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /breaktimes/1
  def update
    if @breaktime.update(breaktime_params)
      render json: @breaktime
    else
      render json: @breaktime.errors, status: :unprocessable_entity
    end
  end

  # DELETE /breaktimes/1
  def destroy
    @breaktime.destroy
    if @breaktime.destroy
      render json: true
    else
      render json: false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_breaktime
      @breaktime = BreakTime.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def breaktime_params
      params.require(:break_time).permit!#$(:reasion, :start_time, :end_time, :total_minutes,:shifttransaction_id,  :start_time_dummy,:end_time_dumy)
    end
end
end
end
