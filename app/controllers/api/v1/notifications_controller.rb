module Api
  module V1
    class NotificationsController < ApplicationController
      # GET /notifications
      def insert_notification
      	Alarm.notification(params)
        #render json: {"machine_log_id": params[:machine_log_id], "machine_log_status": params[:machine_log_status]}
      end

      def alert_all
        #cipher = Gibberish::AES.new('p4ssw0rd')
        notification=Notification.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).order("created_at DESC").last(20)
      # note = cipher.encrypt("notification")
render json: notification
       # render json: note
      end
      
      

    end
  end
end  