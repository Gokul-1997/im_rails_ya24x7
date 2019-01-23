class OneSignalsController < ApplicationController
  before_action :set_one_signal, only: [:show, :update, :destroy]

  # GET /one_signals
  def index
    @one_signals = OneSignal.all

    render json: @one_signals
  end

  # GET /one_signals/1
  def show
    render json: @one_signal
  end

  # POST /one_signals
  def create
    @one_signal = OneSignal.new(one_signal_params)

    if @one_signal.save
      render json: @one_signal, status: :created, location: @one_signal
    else
      render json: @one_signal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /one_signals/1
  def update
    if @one_signal.update(one_signal_params)
      render json: @one_signal
    else
      render json: @one_signal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /one_signals/1
  def destroy
    @one_signal.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_one_signal
      @one_signal = OneSignal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def one_signal_params
      params.require(:one_signal).permit(:player_id, :user_id, :tenant_id)
    end
end
