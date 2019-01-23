module Api
  module V1
    class DeviceMappingsController < ApplicationController
      before_action :set_device_mapping, only: [:show, :update, :destroy]

      # GET /device_mappings
      def index
        @device_mappings = DeviceMapping.all

        render json: @device_mappings
      end

      def active_device 
        @device_mappings = DeviceMapping.where(device_id: params[:id])
        
        render json: @device_mappings
      end
      
      def avialable_device
        @device = Device.where(is_active: true)

        render json: @device
      end

      def active_tenant
        
        @tenant = Tenant.where(isactive: true).to_json(:only => [:id,:tenant_name])

        render json: @tenant
      end


      # GET /device_mappings/1
      def show
        render json: @device_mapping
      end

      # POST /device_mappings
      def create
        @device_mapping = DeviceMapping.new(device_mapping_params)

        if @device_mapping.save
          @device_mapping.device.update(is_active: false)
          render json: @device_mapping, status: :created, location: @device_mapping
        else
          render json: @device_mapping.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /device_mappings/1
      def update
        if @device_mapping.update(removing_date: params[:device_mapping][:removing_date], reasons: params[:device_mapping][:reasons], is_active: false)
          if @device_mapping.is_active == false
            @device_mapping.device.update(is_active: true)
          end
          render json: @device_mapping
        else
          render json: @device_mapping.errors, status: :unprocessable_entity
        end
      end

      # DELETE /device_mappings/1
      def destroy
        @device_mapping.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_device_mapping
          @device_mapping = DeviceMapping.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def device_mapping_params
          params.require(:device_mapping).permit(:installing_date, :removing_date, :number_of_machine, :reasons, :description, :created_by, :updated_by, :is_active, :deleted_at, :tenant_id, :device_id)
        end
    end
  end
end