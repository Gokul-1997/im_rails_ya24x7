class AlarmHistoriesController < ApplicationController
  before_action :set_alarm_history, only: [:show, :update, :destroy]

  # GET /alarm_histories
  def index
    @alarm_histories = AlarmHistory.all

    render json: @alarm_histories
  end

  # GET /alarm_histories/1
  def show
    render json: @alarm_history
  end

  # POST /alarm_histories
  def create
    @alarm_history = AlarmHistory.new(alarm_history_params)

    if @alarm_history.save
      render json: @alarm_history, status: :created, location: @alarm_history
    else
      render json: @alarm_history.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alarm_histories/1
  def update
    if @alarm_history.update(alarm_history_params)
      render json: @alarm_history
    else
      render json: @alarm_history.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarm_histories/1
  def destroy
    @alarm_history.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alarm_history
      @alarm_history = AlarmHistory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarm_history_params
      params.require(:alarm_history).permit(:alarm_type, :alarm_no, :axis_no, :time, :message, :alarm_status, :machine_id)
    end
end
