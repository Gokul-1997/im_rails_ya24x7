class AlarmCodesController < ApplicationController
  before_action :set_alarm_code, only: [:show, :update, :destroy]

  # GET /alarm_codes
  def index
    @alarm_codes = AlarmCode.all

    render json: @alarm_codes
  end

  # GET /alarm_codes/1
  def show
    render json: @alarm_code
  end

  # POST /alarm_codes
  def create
    @alarm_code = AlarmCode.new(alarm_code_params)

    if @alarm_code.save
      render json: @alarm_code, status: :created, location: @alarm_code
    else
      render json: @alarm_code.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alarm_codes/1
  def update
    if @alarm_code.update(alarm_code_params)
      render json: @alarm_code
    else
      render json: @alarm_code.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarm_codes/1
  def destroy
    @alarm_code.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alarm_code
      @alarm_code = AlarmCode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarm_code_params
      params.require(:alarm_code).permit(:code, :description)
    end
end
