class ApprovalsController < ApplicationController
  before_action :set_approval, only: [:show, :update, :destroy]

  # GET /approvals
  def index
    @approvals = Approval.all

    render json: @approvals
  end

  # GET /approvals/1
  def show
    render json: @approval
  end

  # POST /approvals
  def create
    @approval = Approval.new(approval_params)

    if @approval.save
      render json: @approval, status: :created, location: @approval
    else
      render json: @approval.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /approvals/1
  def update
    if @approval.update(approval_params)
      render json: @approval
    else
      render json: @approval.errors, status: :unprocessable_entity
    end
  end

  # DELETE /approvals/1
  def destroy
    @approval.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_approval
      @approval = Approval.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def approval_params
      params.require(:approval).permit(:approval_status_name, :description)
    end
end
