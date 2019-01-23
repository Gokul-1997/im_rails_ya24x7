class NodetestsController < ApplicationController
  before_action :set_nodetest, only: [:show, :update, :destroy]

  # GET /nodetests
  def index
    @nodetests = Nodetest.all

    render json: @nodetests
  end

  # GET /nodetests/1
  def show
    render json: @nodetest
  end

  # POST /nodetests
  def create
byebug
    @nodetest = Nodetest.new(nodetest_params)

    if @nodetest.save
      render json: @nodetest, status: :created, location: @nodetest
    else
      render json: @nodetest.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /nodetests/1
  def update
    if @nodetest.update(nodetest_params)
      render json: @nodetest
    else
      render json: @nodetest.errors, status: :unprocessable_entity
    end
  end

  # DELETE /nodetests/1
  def destroy
    @nodetest.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nodetest
      @nodetest = Nodetest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def nodetest_params
      params.require(:nodetest).permit(:name, :m_no)
    end
end
