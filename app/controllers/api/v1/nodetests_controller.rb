module Api
  module V1
  class NodetestsController < ApplicationController
  before_action :set_nodetest, only: [:show, :update, :destroy]

  # GET /alarm_types
  def index
    @node_tests = Nodetest.all

    render json: @node_tests
  end

  # GET /alarm_types/1
  def show
    render json: @node_test
  end

  # POST /alarm_types
  def create
    
    @node_test = Nodetest.new(nodetest_params)
    if @node_test.m_no.present? &&  Nodetest.last.present?
      if @node_test.m_no == Nodetest.last.m_no
          
          Nodetest.where(m_no: params[:m_no]).last.update(updated_at:Time.now)
      else
          @node_test.save
      end
    elsif @node_test.m_no.present?
        @node_test.save
   #   render json: @node_test.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /alarm_types/1
  def update
    if @node_test.update(nodetest_params)
      render json: @alarm_type
    else
      render json: @alarm_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /alarm_types/1
  def destroy
    @alarm_type.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nodetest
      @node_test = Nodetest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def nodetest_params
      params.require(:nodetest).permit!
    end
end
end
end