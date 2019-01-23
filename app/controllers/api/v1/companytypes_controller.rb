module Api
  module V1
class CompanytypesController < ApplicationController
  before_action :set_companytype, only: [:show, :update, :destroy]

  # GET /companytypes
  def index
    @companytypes = Companytype.all

    render json: {"companytypes": @companytypes}
  end

  # GET /companytypes/1
  def show
    render json: @companytype
  end

  # POST /companytypes
  def create
    @companytype = Companytype.new(companytype_params)

    if @companytype.save
      render json: @companytype ,status: :created#, location: @companytype
    else
      render json: @companytype.errors# status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companytypes/1
  def update
    if @companytype.update(companytype_params)
      render json: @companytype
    else
      render json: @companytype.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companytypes/1
  def destroy
    @companytype.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_companytype
      @companytype = Companytype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def companytype_params
      params.require(:companytype).permit(:companytype_name, :description)
    end
end
end
end
