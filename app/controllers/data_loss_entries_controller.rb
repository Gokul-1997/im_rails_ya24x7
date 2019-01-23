class DataLossEntriesController < ApplicationController
  before_action :set_data_loss_entry, only: [:show, :update, :destroy]

  # GET /data_loss_entries
  def index
    @data_loss_entries = DataLossEntry.all

    render json: @data_loss_entries
  end

  # GET /data_loss_entries/1
  def show
    render json: @data_loss_entry
  end

  # POST /data_loss_entries
  def create
    @data_loss_entry = DataLossEntry.new(data_loss_entry_params)

    if @data_loss_entry.save
      render json: @data_loss_entry, status: :created, location: @data_loss_entry
    else
      render json: @data_loss_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_loss_entries/1
  def update
    if @data_loss_entry.update(data_loss_entry_params)
      render json: @data_loss_entry
    else
      render json: @data_loss_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /data_loss_entries/1
  def destroy
    @data_loss_entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_loss_entry
      @data_loss_entry = DataLossEntry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def data_loss_entry_params
      params.require(:data_loss_entry).permit(:start_time, :end_time, :downtime, :parts_produced, :machine_id)
    end
end
