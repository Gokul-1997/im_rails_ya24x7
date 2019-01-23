class MenuconfigurationsController < ApplicationController
  before_action :set_menuconfiguration, only: [:show, :update, :destroy]

  # GET /menuconfigurations
  def index
    @menuconfigurations = Menuconfiguration.all

    render json: @menuconfigurations
  end

  # GET /menuconfigurations/1
  def show
    render json: @menuconfiguration
  end

  # POST /menuconfigurations
  def create
    @menuconfiguration = Menuconfiguration.new(menuconfiguration_params)

    if @menuconfiguration.save
      render json: @menuconfiguration, status: :created, location: @menuconfiguration
    else
      render json: @menuconfiguration.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /menuconfigurations/1
  def update
    if @menuconfiguration.update(menuconfiguration_params)
      render json: @menuconfiguration
    else
      render json: @menuconfiguration.errors, status: :unprocessable_entity
    end
  end

  # DELETE /menuconfigurations/1
  def destroy
    @menuconfiguration.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menuconfiguration
      @menuconfiguration = Menuconfiguration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def menuconfiguration_params
      params.require(:menuconfiguration).permit(:page_id, :role_id, :pageauthorization_id, :tenant_id)
    end
end
