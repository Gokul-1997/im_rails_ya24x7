class MachineSeriesNosController < ApplicationController
  before_action :set_machine_series_no, only: [:show, :update, :destroy]

  # GET /machine_series_nos
  def index
    @machine_series_nos = MachineSeriesNo.all

    render json: @machine_series_nos
  end

  # GET /machine_series_nos/1
  def show
    render json: @machine_series_no
  end

  # POST /machine_series_nos
  def create
    @machine_series_no = MachineSeriesNo.new(machine_series_no_params)

    if @machine_series_no.save
      render json: @machine_series_no, status: :created, location: @machine_series_no
    else
      render json: @machine_series_no.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /machine_series_nos/1
  def update
    if @machine_series_no.update(machine_series_no_params)
      render json: @machine_series_no
    else
      render json: @machine_series_no.errors, status: :unprocessable_entity
    end
  end

  # DELETE /machine_series_nos/1
  def destroy
    @machine_series_no.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine_series_no
      @machine_series_no = MachineSeriesNo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def machine_series_no_params
      params.require(:machine_series_no).permit(:number, :controller_name)
    end
end
