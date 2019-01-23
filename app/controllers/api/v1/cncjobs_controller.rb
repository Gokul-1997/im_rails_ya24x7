module Api
  module V1
    class CncjobsController < ApplicationController
  before_action :set_cncjob, only: [:show, :update, :destroy]

  # GET /cncjobs
  def index
      @cncjobs = Tenant.find(params[:tenant_id]).cncjobs
     render json: @cncjobs
   end

  def job_filter
     if params[:completed_status].present?
         if params[:completed_status] == 0
           @cncjobs = Tenant.find(params[:tenant_id]).cncjobs.where("job_due_date <?" ,Date.today)
         elsif params[:completed_status] == 1
           @cncjobs = Tenant.find(params[:tenant_id]).cncjobs.where("job_start_date <= ? AND job_due_date >= ?",Date.today,Date.today)
         else
           @cncjobs = Tenant.find(params[:tenant_id]).cncjobs.where("job_start_date > ?",Date.today)
          end
    else
      @cncjobs = Tenant.find(params[:tenant_id]).cncjobs
    end
    render json: @cncjobs
  end

  # GET /cncjobs/1
  def show
    render json: @cncjob
  end

  def opration_details
     operation_details = Cncjob.operation_detail(params)
    render json: operation_details
  end

  # POST /cncjobs
  def create
    @cncjob = Cncjob.new(cncjob_params)

    if @cncjob.save
      render json: @cncjob, status: :created#, location: @cncjob
    else
      render json: @cncjob.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cncjobs/1
  def update
    if @cncjob.update(cncjob_params)
      render json: @cncjob
    else
      render json: @cncjob.errors, status: :unprocessable_entity
    end
  end

  def job_list
    jobs=Tenant.find(params[:tenant_id]).cncjobs
    render json: jobs
  end

  def all_jobs
    all_jobs = Cncjob.get_all_jobs(params)
    render json: all_jobs
  end

  def job_detail
    job_details = Cncjob.job_details(params)
    render json: job_details
  end

  def job_page_details
    data = Cncjob.job_page(params)
    render json: data
  end

  def job_page_operation
    operation_data = Cncjob.job_page_operation(params)
    render json: operation_data
  end
  #def job_page_details
  #  data = MachineLog.job_details(params)
   # render json: data
  #end

 # def job_page
  # DELETE /cncjobs/1
  def destroy
    @cncjob.destroy
    if @cncjob.destroy
      render json: true
    else
      render json: false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncjob
      @cncjob = Cncjob.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncjob_params
      params.require(:cncjob).permit(:description, :job_start_date, :job_due_date, :order_quantity, :cncclient_id, :tenant_id,:job_id,:cycle_time,:idle_cycle_time)
    end
end
end
end