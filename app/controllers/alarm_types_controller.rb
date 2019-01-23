class AlarmTypesController < ApplicationController
  before_action :set_alarm_type, only: [:show, :update, :destroy]

  # GET /alarm_types
  def index
    @alarm_types = AlarmType.all

    render json: @alarm_types
  end

  # GET /alarm_types/1
  def show
    render json: @alarm_type
  end

  # POST /alarm_types
  def create
    @alarm_type = AlarmType.new(alarm_type_params)

    if @alarm_type.save
      render json: @alarm_type, status: :created, location: @alarm_type
    else
      render json: @alarm_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alarm_types/1
  def update
    if @alarm_type.update(alarm_type_params)
      render json: @alarm_type
    else
      render json: @alarm_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarm_types/1
  def destroy
    @alarm_type.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alarm_type
      @alarm_type = AlarmType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarm_type_params
      params.require(:alarm_type).permit(:alarm_name)
    end
end
