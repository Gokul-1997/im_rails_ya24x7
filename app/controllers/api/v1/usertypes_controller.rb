module Api
  module V1
class UsertypesController < ApplicationController
  before_action :set_usertype, only: [:show, :update, :destroy]

  # GET /usertypes
  def index
    @usertypes = Usertype.all

    render json: @usertypes
  end

  # GET /usertypes/1
  def show
    render json: @usertype
  end

  # POST /usertypes
  def create
    @usertype = Usertype.new(usertype_params)

    if @usertype.save
      render json: @usertype, status: :created
    else
      render json: @usertype.errors# status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usertypes/1
  def update
    if @usertype.update(usertype_params)
      render json: @usertype
    else
      render json: @usertype.errors, status: :unprocessable_entity
    end
  end

  # DELETE /usertypes/1
  def destroy
    @usertype.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usertype
      @usertype = Usertype.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def usertype_params
      params.require(:usertype).permit(:usertype_name, :description)
    end
end
end
end