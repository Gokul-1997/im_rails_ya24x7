class JobListsController < ApplicationController
  before_action :set_job_list, only: [:show, :update, :destroy]

  # GET /job_lists
  def index
    @job_lists = JobList.all

    render json: @job_lists
  end

  # GET /job_lists/1
  def show
    render json: @job_list
  end

  # POST /job_lists
  def create
    @job_list = JobList.new(job_list_params)

    if @job_list.save
      render json: @job_list, status: :created, location: @job_list
    else
      render json: @job_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_lists/1
  def update
    if @job_list.update(job_list_params)
      render json: @job_list
    else
      render json: @job_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_lists/1
  def destroy
    @job_list.destroy
  end

  def pending_customer_dc_list
    data = Cncclient.find(params[:client_id]).job_lists.where(completed_status:0)
    byebug
    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_list
      @job_list = JobList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_list_params
      params.require(:job_list).permit(:client_dc_no, :j_name, :j_id, :fresh_pecs, :rework_pecs, :reject_pecs, :notes, :cncclient_id)
    end
end
