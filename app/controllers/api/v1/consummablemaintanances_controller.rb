#module Api
 # module V1
#class ConsummablemaintanancesController < ApplicationController
#  before_action :set_consummablemaintanance, only: [:show, :update, :destroy]

  # GET /consummablemaintanances
 # def index
  #  @consummablemaintanances = Consummablemaintanance.all

   # render json: @consummablemaintanances
  #end

  # GET /consummablemaintanances/1
 # def show
  #  render json: @consummablemaintanance
  #end

  # POST /consummablemaintanances
 # def create
  #  @consummablemaintanance = Consummablemaintanance.new(consummablemaintanance_params)

   # if @consummablemaintanance.save
    #  render json: @consummablemaintanance, status: :created, location: @consummablemaintanance
   # else
    #  render json: @consummablemaintanance.errors, status: :unprocessable_entity
   # end
 # end

  # PATCH/PUT /consummablemaintanances/1
#  def update
 #   if @consummablemaintanance.update(consummablemaintanance_params)
  #    render json: @consummablemaintanance
  #  else
   #   render json: @consummablemaintanance.errors, status: :unprocessable_entity
   # end
  #end

  # DELETE /consummablemaintanances/1
 # def destroy
  #  @consummablemaintanance.destroy
  #end

 # private
    # Use callbacks to share common setup or constraints between actions.
  #  def set_consummablemaintanance
   #   @consummablemaintanance = Consummablemaintanance.find(params[:id])
   # end

    # Only allow a trusted parameter "white list" through.
   # def consummablemaintanance_params
    #  params.require(:consummablemaintanance).permit(:maintance_type, :change_date, :next_change_date, :reason_for_change, :machine_id, :tenant_id)
   # end
#end
#end
