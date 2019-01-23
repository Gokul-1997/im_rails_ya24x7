class MacIdConfigsController < ApplicationController
  before_action :set_mac_id_config, only: [:show, :update, :destroy]

  # GET /mac_id_configs
  def index
    @mac_id_configs = MacIdConfig.all

    render json: @mac_id_configs
  end

  # GET /mac_id_configs/1
  def show
    render json: @mac_id_config
  end

  # POST /mac_id_configs
  def create
    @mac_id_config = MacIdConfig.new(mac_id_config_params)

    if @mac_id_config.save
      render json: @mac_id_config, status: :created, location: @mac_id_config
    else
      render json: @mac_id_config.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mac_id_configs/1
  def update
    if @mac_id_config.update(mac_id_config_params)
      render json: @mac_id_config
    else
      render json: @mac_id_config.errors, status: :unprocessable_entity
    end
  end

  # DELETE /mac_id_configs/1
  def destroy
    @mac_id_config.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mac_id_config
      @mac_id_config = MacIdConfig.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def mac_id_config_params
      params.require(:mac_id_config).permit(:mac_id, :player_id)
    end
end
