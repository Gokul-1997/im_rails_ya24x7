module Api
  module V1
class CncoperationsController < ApplicationController
  before_action :set_cncoperation, only: [:show, :update, :destroy]

  # GET /cncoperations
  def index
    @cncoperations = Cncoperation.all

    render json: @cncoperations
  end

  # GET /cncoperations/1
  def show
    render json: @cncoperation
  end

  # POST /cncoperations
  def create
    @cncoperation = Cncoperation.new(cncoperation_params)
    no = (params[:operation_no].to_i*10).to_s
    operation_no  =  @cncoperation.cncjob.job_id+"-"+no
    total_cycle_time = Time.parse(@cncoperation.cycle_time).seconds_since_midnight + Time.parse(@cncoperation.idle_cycle_time).seconds_since_midnight
    total_cycle_time = Time.at(total_cycle_time).utc.strftime("%H:%M:%S")
    @cncoperation.update(description:operation_no,total_cycle_time:total_cycle_time)


    if @cncoperation.save
      render json: @cncoperation, status: :created#, location: @cncoperation
    else
      render json: @cncoperation.errors, status: :unprocessable_entity
    end
    
  end

  # PATCH/PUT /cncoperations/1
  def update

        if @cncoperation.update(cncoperation_params)
        no = (params[:operation_no].to_i*10).to_s
       operation_no  =  @cncoperation.cncjob.job_id+"-"+no
       total_cycle_time = Time.parse(@cncoperation.cycle_time).seconds_since_midnight + Time.parse(@cncoperation.idle_cycle_time).seconds_since_midnight
       total_cycle_time = Time.at(total_cycle_time).utc.strftime("%H:%M:%S")
       @cncoperation.update(description:operation_no,total_cycle_time:total_cycle_time)
      render json: @cncoperation
    else
      render json: @cncoperation.errors, status: :unprocessable_entity
    end
  end
  def cncoperation_list
    cncoperation = Cncoperation.get_operation(params)
    render json: cncoperation
   end

  # DELETE /cncoperations/1
  def destroy
    @cncoperation.destroy
   if @cncoperation.destroy
      render json: true
    else
      render json: false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncoperation
      @cncoperation = Cncoperation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncoperation_params
      params.require(:cncoperation).permit!
    end
end
end
end
