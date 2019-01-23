class CncjobsController < ApplicationController
  before_action :set_cncjob, only: [:show, :update, :destroy]

  # GET /cncjobs
  def index
    @cncjobs = Cncjob.all

    render json: @cncjobs
  end

  # GET /cncjobs/1
  def show
    render json: @cncjob
  end

  # POST /cncjobs
  def create
    @cncjob = Cncjob.new(cncjob_params)

    if @cncjob.save
      render json: @cncjob, status: :created, location: @cncjob
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

  # DELETE /cncjobs/1
  def destroy
    @cncjob.destroy
  end

  def all_jobs
    all_jobs = Cncjob.get_all_jobs(params)
    render json: all_jobs
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cncjob
      @cncjob = Cncjob.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cncjob_params
      params.require(:cncjob).permit(:description, :job_start_date, :job_due_date, :order_quantity, :cncclient_id, :tenant_id)
    end
end
