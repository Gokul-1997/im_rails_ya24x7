class ShifttransactionsController < ApplicationController
  before_action :set_shifttransaction, only: [:show, :update, :destroy]

  # GET /shifttransactions
  def index
    @shifttransactions = Shifttransaction.all

    render json: @shifttransactions
  end

  # GET /shifttransactions/1
  def show
    render json: @shifttransaction
  end

  # POST /shifttransactions
  def create
    @shifttransaction = Shifttransaction.new(shifttransaction_params)

    if @shifttransaction.save
      render json: @shifttransaction, status: :created, location: @shifttransaction
    else
      render json: @shifttransaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifttransactions/1
  def update
    if @shifttransaction.update(shifttransaction_params)
      render json: @shifttransaction
    else
      render json: @shifttransaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifttransactions/1
  def destroy
    @shifttransaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shifttransaction
      @shifttransaction = Shifttransaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shifttransaction_params
      params.require(:shifttransaction).permit!#(:shift_start_time, :shift_end_time, :actual_working_hours, :shift_id,:shift_no)
    end
end
