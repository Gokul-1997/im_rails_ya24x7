class DeliveryListsController < ApplicationController
  before_action :set_delivery_list, only: [:show, :update, :destroy]

  # GET /delivery_lists
  def index
    @delivery_lists = DeliveryList.all

    render json: @delivery_lists
  end

  # GET /delivery_lists/1
  def show
    render json: @delivery_list
  end

  # POST /delivery_lists
  def create
    @delivery_list = DeliveryList.new(delivery_list_params)

    if @delivery_list.save
      render json: @delivery_list, status: :created, location: @delivery_list
    else
      render json: @delivery_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /delivery_lists/1
  def update
    if @delivery_list.update(delivery_list_params)
      render json: @delivery_list
    else
      render json: @delivery_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /delivery_lists/1
  def destroy
    @delivery_list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_list
      @delivery_list = DeliveryList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def delivery_list_params
      params.require(:delivery_list).permit(:client_dc_no, :our_dc_no, :j_name, :j_id, :fresh_pecs, :rework_pecs, :reject_pecs, :notes, :job_list_id)
    end
end
