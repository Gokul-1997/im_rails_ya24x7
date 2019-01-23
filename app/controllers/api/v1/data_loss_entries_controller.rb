
module Api
  module V1
  class DataLossEntriesController < ApplicationController
  before_action :set_data_loss_entry, only: [:show, :update, :destroy]

  # GET /data_loss_entries
  def index
    @data_loss_entries = DataLossEntry.includes(:machine).where(machine_id:Tenant.find(params[:tenant_id]).machines.ids,entry_status:false).where('updated_at > ?', 3.days.ago) 
    @data_loss_entries = @data_loss_entries.empty? ? false : @data_loss_entries
    render json: @data_loss_entries
  end

  # GET /data_loss_entries/1
  def show
    render json: @data_loss_entry
  end

  # POST /data_loss_entries

  def update_data
    data = params[:data]
    data.map do |ff| 
       data_loss_entry = DataLossEntry.find ff[:id]

      unless ff[:downtime].nil? && ff[:parts_produced].nil? && ff[:program_no].nil?
        DataLossEntry.find(ff[:id]).update(parts_produced:ff[:parts_produced],downtime:ff[:downtime],program_no:ff[:program_no],entry_status:true,run_time:(data_loss_entry.end_time - data_loss_entry.start_time)-ff[:downtime].to_i*60)  
      end
    end
  end

  def created
    @data_loss_entry = DataLossEntry.new(data_loss_entry_params)
     
    if @data_loss_entry.save
      render json: @data_loss_entry, status: :created#, location: @data_loss_entry
    else
      render json: @data_loss_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_loss_entries/1
  def update
    if @data_loss_entry.update(data_loss_entry_params)
      @data_loss_entry.run_time = (@data_loss_entry.end_time - @data_loss_entry.start_time) - @data_loss_entry.downtime*60
      @data_loss_entry.update(entry_status: true)
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
      params.require(:data_loss_entry).permit!#(:start_time, :end_time, :downtime, :parts_produced, :machine_id)
    end
end
end
end