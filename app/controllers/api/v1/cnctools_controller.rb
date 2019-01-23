module Api
  module V1
class CnctoolsController < ApplicationController
  before_action :set_cnctool, only: [:show, :update, :destroy]

  # GET /cnctools
  def index
    @cnctools = Cnctool.all

    render json: @cnctools
  end

  # GET /cnctools/1
  def show
    render json: @cnctool
  end

  # POST /cnctools
  def create
    @cnctool = Cnctool.new(cnctool_params)

    if @cnctool.save
      render json: @cnctool, status: :created, location: @cnctool
    else
      render json: @cnctool.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cnctools/1
  def update
    if @cnctool.update(cnctool_params)
      render json: @cnctool
    else
      render json: @cnctool.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cnctools/1
  def destroy
    @cnctool.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cnctool
      @cnctool = Cnctool.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cnctool_params
      params.require(:cnctool).permit(:tool_name, :no_of_parts, :material_string, :produced_count, :tenant_id, :machine_id)
    end
end
end
end