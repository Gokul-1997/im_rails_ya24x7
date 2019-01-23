module Api
  module V1
class PageauthorizationsController < ApplicationController
  before_action :set_pageauthorization, only: [:show, :update, :destroy]

  # GET /pageauthorizations
  def index
    @pageauthorizations = Pageauthorization.all

    render json: @pageauthorizations
  end

  # GET /pageauthorizations/1
  def show
    render json: @pageauthorization
  end

  # POST /pageauthorizations
  def create
    @pageauthorization = Pageauthorization.new(pageauthorization_params)

    if @pageauthorization.save
      render json: @pageauthorization, status: :created, location: @pageauthorization
    else
      render json: @pageauthorization.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pageauthorizations/1
  def update
    if @pageauthorization.update(pageauthorization_params)
      render json: @pageauthorization
    else
      render json: @pageauthorization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pageauthorizations/1
  def destroy
    @pageauthorization.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pageauthorization
      @pageauthorization = Pageauthorization.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pageauthorization_params
      params.require(:pageauthorization).permit(:authorization_name, :description)
    end
end
end
end