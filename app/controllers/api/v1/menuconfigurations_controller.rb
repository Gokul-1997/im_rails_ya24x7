module Api
  module V1
class MenuconfigurationsController < ApplicationController
  before_action :set_menuconfiguration, only: [:show, :update, :destroy]

  # GET /menuconfigurations
  def index
  if params[:tenant_id] && params[:role_id]
    @menuconfigurations = Menuconfiguration.where(tenant_id:params[:tenant_id],role_id:params[:role_id])
  end
    render json: @menuconfigurations
  end
  def page_detail
    if params[:tenant_id] && params[:role_id]
     @menuconfigurations = Menuconfiguration.where(tenant_id:params[:tenant_id],role_id:params[:role_id])
     data = @menuconfigurations.map {|pp| {:page_name=>pp.page.page_name,:role_name=>pp.role.role_name,:pageauthorization=>pp.pageauthorization.authorization_name,:icon=>pp.page.icon,:url=>pp.page.url}}
    end
    render json: data
  end
  # GET /menuconfigurations/1
  def show
    render json: @menuconfiguration
  end

  # POST /menuconfigurations
  def create
   if params[:role_id].present?
     Role.find(params[:role_id]).menuconfigurations.delete_all
   end
    data = []
    tenant_id = params[:menuconfiguration][:tenant_id].to_i
    role_id = params[:menuconfiguration][:role_id].to_i
    pageauthorization_id = params[:menuconfiguration][:pageauthorization_id].to_i
    
      params[:menuconfiguration][:page_id].map do |page|
      data << Menuconfiguration.create(page_id:page,role_id:role_id,tenant_id:tenant_id,pageauthorization_id:pageauthorization_id)
    end
    render json: data
   # @menuconfiguration = Menuconfiguration.new(menuconfiguration_params)

    #if @menuconfiguration.save
     # render json: @menuconfiguration, status: :created#, location: @menuconfiguration
    #else
    #  render json: @menuconfiguration.errors, status: :unprocessable_entity
    #end
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
end
end