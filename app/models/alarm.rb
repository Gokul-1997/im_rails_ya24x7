  require 'byebug'
  require 'net/http'
    require 'net/https'
  class Alarm < ApplicationRecord
    acts_as_paranoid
    belongs_to :machine

    delegate :machine_name, :to => :machine, :prefix => true # law of demeter in bestpractices

  def self.notification(machine_log)
      #machine_log = MachineLog.find(5734343)
      machine = machine_log.machine.id
      machine_name = machine_log.machine.machine_name # law of demeter in bestpractices
      #if machine_log.machine.tenant.setting.present?
     # if machine_log.machine.tenant.setting.notification == true

     if machine_log.machine.set_alarm_settings.present?
      
       player_id = OneSignal.where(user_id:machine_log.machine.tenant.user.id).pluck(:player_id).uniq
       if player_id.present? 
           if machine_log.machine_status == 100
           status = "Stop"
          elsif machine_log.machine_status == 0
             status = "Idle"
          else 
             status = "Running"
          end
          
          alarm_time = machine_log.machine.set_alarm_settings
    
          alarm_time.each do |alarm|
            
            if alarm.time_interval != nil && alarm.active == true
              message = machine_name + " : " + status
              
              if Notification.where(message: message, machine_id:machine).count == 0
                
                 Notification.create(machine_log_id: machine_log.id,message: message,machine_id:machine)
                params = {"app_id" => "61c6c36b-9640-4d15-8b00-2a9a4559b626", 
                "contents" => {"en" => "#{message}"},
                "include_player_ids" => player_id}
                uri = URI.parse('https://onesignal.com/api/v1/notifications')
                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true
                request = Net::HTTP::Post.new(uri.path, 'Content-Type'  => 'application/json;charset=utf-8', 'Authorization' => "Basic NjI2OWIzZjktYmRmZi00NTUzLTg5N2EtZmE4YzIyOTExM2U4")
                request.body = params.as_json.to_json
                response = http.request(request)
                puts response.body 
                puts "done"
              elsif Notification.where(message: message, machine_id: machine).order(:id).last.created_at + alarm.time_interval.to_i.minutes < Time.now && machine_log.machine.machine_logs.where(machine_status: '3').last.created_at + alarm.time_interval.to_i.minutes < Time.now
                
               

                Notification.create(machine_log_id: machine_log.id,message: message,machine_id:machine)
                
                params = {"app_id" => "61c6c36b-9640-4d15-8b00-2a9a4559b626", 
                "contents" => {"en" => "#{message}"},
                "include_player_ids" => player_id}
                
                uri = URI.parse('https://onesignal.com/api/v1/notifications')
                
                http = Net::HTTP.new(uri.host, uri.port)
                
                http.use_ssl = true
                
                request = Net::HTTP::Post.new(uri.path, 'Content-Type'  => 'application/json;charset=utf-8', 'Authorization' => "Basic NjI2OWIzZjktYmRmZi00NTUzLTg5N2EtZmE4YzIyOTExM2U4")
                
                request.body = params.as_json.to_json
                
                response = http.request(request)
                
                puts response.body
                puts "done"
              else
                puts "time wrongff"
              end
           # end
            else
              puts "set_alarm_settings time_interval or alarm_time nill"
          end

       end  # do
     else
      puts "player_id not Present"
     end
   else
    puts "set_alarm_settings not present"
   end

   #else
   #puts "Notificeation no need"
   #end

 #else
  #puts "this tenant was no Setting"
  #end
 end   
          

  

  def self.alarm_report(params)
      date = params[:start_date]
      tenant=Tenant.find(params[:tenant_id])
      machines=params[:machine_id].present? ? Machine.where(id:params[:machine_id]) : tenant.machines 
      shiftstarttime=tenant.shift.day_start_time
      if params[:report_type] == "Shiftwise"
        (params[:start_date].to_date..params[:end_date].to_date).map(&:to_s).map do |date|
          shifts = params[:shift_id].present? ? Shifttransaction.where(id:params[:shift_id]) : tenant.shift.shifttransactions
           shifts.map do |shift|
              

              # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
              #       start_time = (date+" "+shift.shift_start_time).to_time
              #       end_time = (date+" "+shift.shift_end_time).to_time+1.day        
              # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
              #       start_time = (date+" "+shift.shift_start_time).to_time+1.day
              #       end_time = (date+" "+shift.shift_end_time).to_time+1.day
              # else
              #       start_time = (date+" "+shift.shift_start_time).to_time
              #       end_time = (date+" "+shift.shift_end_time).to_time        
              # end

         if tenant.id != 31 || tenant.id != 10
          if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
            if Time.now.strftime("%p") == "AM"
              date = (Date.today - 1).strftime("%Y-%m-%d")
            end 
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time+1.day                       
          elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")                
            if Time.now.strftime("%p") == "AM"
              date = (Date.today - 1).strftime("%Y-%m-%d")
            end
              start_time = (date+" "+shift.shift_start_time).to_time+1.day
              end_time = (date+" "+shift.shift_end_time).to_time+1.day
          else
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time        
          end
        else
           case
          when shift.day == 1 && shift.end_day == 1   
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time  
          when shift.day == 1 && shift.end_day == 2
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time+1.day    
          else
            start_time = (date+" "+shift.shift_start_time).to_time+1.day
            end_time = (date+" "+shift.shift_end_time).to_time+1.day     
          end
        end




                end_time_for_ideal = Time.now < end_time ? Time.now : end_time
                total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
              machines.map do | machine|
               machine.alarms.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id).map do | alarm|
                 operator_name = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : "Not Assigned"
                 operator_id = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_spec_id : "Not Assigned"
                 update=alarm.updated_at.strftime("%H:%M:%S")
                 create=alarm.created_at.strftime("%H:%M:%S")
                duration =  update.to_time - create.to_time
                  data ={
                  date:date,
                  time:shift.shift_start_time+' - '+shift.shift_end_time,
                  shift_no:shift.shift_no,
                  alarm_type:alarm.present? ? alarm.alarm_type : 0,
                  alarm_number:alarm.present? ? alarm.alarm_number : 0,
                  alarm_message:alarm.present? ? alarm.alarm_message : 0,
                  #emergency:alarm.present? ?alarm.emergency : 0,
                  machine_name:alarm.present? ? alarm.machine.machine_name : 0,
                  machine_type:alarm.present? ? alarm.machine.machine_type : 0,
                  operator_name:operator_name,
                  operator_id:operator_id,
                  duration:Time.at(duration).utc.strftime("%H:%M:%S")
                  }
               end
              end
           end
        end

      elsif params[:report_type] == "Operatorwise"
          date_include_operator=OperatorMappingAllocation.where(:date=>params[:start_date].to_date..params[:end_date].to_date,:operator_id=>  params[:operator_id])  
          machines.map do | machine|
          date_include_operator.map do |operator_mapping_row| 
              shift_transaction= operator_mapping_row.operator_allocation.shifttransaction   
              machine_row = operator_mapping_row.operator_allocation.machine
                if shift_transaction.shift_start_time.include?("PM") && shift_transaction.shift_end_time.include?("AM")
                start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time
                end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time+1.day        
                elsif shift_transaction.shift_start_time.include?("AM") && shift_transaction.shift_end_time.include?("AM")
                start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time+1.day
                end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time+1.day
                else
                start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time
                end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time        
                end
                end_time_for_ideal = Time.now < end_time ? Time.now : end_time
                total_shift_time_available = Time.parse(shift_transaction.actual_working_hours).seconds_since_midnight
              
                machine.alarms.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id).map do | alarm|
                  #operator_name = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : "Not Assigned"
                  #operator_id = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_spec_id : "Not Assigned"
                  update=alarm.updated_at.strftime("%H:%M:%S")
                 create=alarm.created_at.strftime("%H:%M:%S")
                duration =  update.to_time - create.to_time
                  data ={
                  :date=>(operator_mapping_row.date).strftime("%F"),
                  :time=>shift_transaction.shift_start_time+' - '+shift_transaction.shift_end_time,
                  :shift_no =>shift_transaction.shift_no,
                  alarm_type:alarm.present? ? alarm.alarm_type : 0,
                  alarm_number:alarm.present? ? alarm.alarm_number : 0,
                  alarm_message:alarm.present? ? alarm.alarm_message : 0,
                  #emergency:alarm.present? ?alarm.emergency : 0,
                  machine_name:alarm.present? ? alarm.machine.machine_name : 0,
                  machine_type:alarm.present? ? alarm.machine.machine_type : 0,
                  operator_name:operator_mapping_row.operator.operator_name,
                  operator_id:operator_mapping_row.operator.operator_spec_id,
                  duration:Time.at(duration).utc.strftime("%H:%M:%S")
                  }
                end
              end
          end
      end
  end

end
