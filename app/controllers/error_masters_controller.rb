class ErrorMastersController < ApplicationController
  before_action :set_error_master, only: [:show, :update, :destroy]

  # GET /error_masters
  def index
    @error_masters = ErrorMaster.all

    render json: @error_masters
  end

  # GET /error_masters/1
  def show
    render json: @error_master
  end

  # POST /error_masters
  def create
    @error_master = ErrorMaster.new(error_master_params)

    if @error_master.save
      render json: @error_master, status: :created, location: @error_master
    else
      render json: @error_master.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /error_masters/1
  def update
    if @error_master.update(error_master_params)
      render json: @error_master
    else
      render json: @error_master.errors, status: :unprocessable_entity
    end
  end

  # DELETE /error_masters/1
  def destroy
    @error_master.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_error_master
      @error_master = ErrorMaster.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def error_master_params
      params.require(:error_master).permit(:error_code, :message, :description)
    end
end
