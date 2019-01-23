class CncclientsController < ApplicationController
  before_action :set_cncclient, only: [:show, :update, :destroy]

  # GET /cncclients
  def index
    @cncclients = Cncclient.all

    render json: @cncclients
  end

  # GET /cncclients/1
  def show
    render json: @cncclient
  end

  # POST /cncclients
  def create
    @cncclient = Cncclient.new(cncclient_params)

    if @cncclient.save
      render json: @cncclient, status: :created, location: @cncclient
    else
      render json: @cncclient.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cncclients/1
  def update
    if @cncclient.update(cncclient_params)
      render json: @cncclient
    else
      render json: @cncclient.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cncclients/1
  def destroy
    @cncclient.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncclient
      @cncclient = Cncclient.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncclient_params
      params.require(:cncclient).permit(:client_name, :email_id, :phone_number, :tenant_id)
    end
end
