class MonthReportsController < ApplicationController
  before_action :set_month_report, only: [:show, :update, :destroy]

  # GET /month_reports
  def index
    @month_reports = MonthReport.all

    render json: @month_reports
  end

  # GET /month_reports/1
  def show
    render json: @month_report
  end

  # POST /month_reports
  def create
    @month_report = MonthReport.new(month_report_params)

    if @month_report.save
      render json: @month_report, status: :created, location: @month_report
    else
      render json: @month_report.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /month_reports/1
  def update
    if @month_report.update(month_report_params)
      render json: @month_report
    else
      render json: @month_report.errors, status: :unprocessable_entity
    end
  end

  # DELETE /month_reports/1
  def destroy
    @month_report.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_month_report
      @month_report = MonthReport.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def month_report_params
      params.fetch(:month_report, {})
    end
end
