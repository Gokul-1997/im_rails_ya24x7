    class MachineDailyLog < ApplicationRecord
  belongs_to :machine, -> { with_deleted }
  serialize :status, Array
  serialize :x_axis, Array
  serialize :y_axis, Array
  serialize :cycle_time_minutes, Array

def self.dashboard_status(params) # The Small View of Dashboard
  tenant=Tenant.find(params[:tenant_id])
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != nil
    date = Date.today.to_s   
    if params[:type] == "Alarm"  # This Alarm Method is common to Small and Big Dashboard
      tenant.machines.order(:id).map do |mac|
       data = {
        unit:mac.unit,
        date:date,
        :machine_id=>mac.id,
        :machine_name=>mac.machine_name,
        :alarm=>mac.alarms.last,
        :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
        :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
        :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
        :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
       }
      end
    else
      if shift != []
      
          case
          when shift.day == 1 && shift.end_day == 1   
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time  
          when shift.day == 1 && shift.end_day == 2
            # start_time = (date+" "+shift.shift_start_time).to_time
            # end_time = (date+" "+shift.shift_end_time).to_time+1.day
            if Time.now.strftime("%p") == "AM"
              start_time = (date+" "+shift.shift_start_time).to_time-1.day
              end_time = (date+" "+shift.shift_end_time).to_time
            else
              start_time = (date+" "+shift.shift_start_time).to_time
              end_time = (date+" "+shift.shift_end_time).to_time+1.day
            end
          else
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time     
          end
       # end
               
        duration = end_time.to_i - start_time.to_i
        tenant.machines.where(controller_type: [1]).order(:id).map do |mac| 
        machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
        total_shift_time_available_for_downtime =  Time.now - start_time
        run_time = Machine.run_time(machine_log)
        utilization = (run_time*100)/duration if duration.present?     
         
          data = {
            :unit => mac.unit,
            :date =>date,
            :start_time=>start_time,
            :shift_no =>shift.shift_no,
            :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
            :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
            :machine_id=>mac.id,
            :machine_name=>mac.machine_name,
            :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
            :utilization=>utilization
          }
        end
      else
        data = { message:"No shift Currently Avaliable" }
      end
    end
  end
end
  

def self.rs232_dashboard(params)
	tenant=Tenant.find(params[:tenant_id])
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != nil
    date = Date.today.to_s   
      if shift != []
           case
          when shift.day == 1 && shift.end_day == 1   
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time  
          when shift.day == 1 && shift.end_day == 2
            # start_time = (date+" "+shift.shift_start_time).to_time
            # end_time = (date+" "+shift.shift_end_time).to_time+1.day
            if Time.now.strftime("%p") == "AM"
              start_time = (date+" "+shift.shift_start_time).to_time-1.day
              end_time = (date+" "+shift.shift_end_time).to_time
            else
              start_time = (date+" "+shift.shift_start_time).to_time
              end_time = (date+" "+shift.shift_end_time).to_time+1.day
            end
          else
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time     
          end
       # end
               
        duration = end_time.to_i - start_time.to_i
        tenant.machines.where(controller_type: 2).order(:id).map do |mac| 
        machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
        total_shift_time_available_for_downtime =  Time.now - start_time
        run_time = Machine.run_time(machine_log)
        utilization = (run_time*100)/duration if duration.present?     
         
          data = {
            :unit => mac.unit,
            :date =>date,
            :start_time=>start_time,
            :shift_no =>shift.shift_no,
            :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
            :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
            :machine_id=>mac.id,
            :machine_name=>mac.machine_name,
            :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
            :utilization=>utilization
          }
        end
      else
        data = { message:"No shift Currently Avaliable" }
      end
    #end
  end
end







def self.dashboard_status10(params) # The Small View of Dashboard
  tenant=Tenant.find(8)
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != nil
    date = Date.today.to_s 
   if params[:type] == "Alarm"  # This Alarm Method is common to Small and Big Dashboard
      tenant.machines.order(:id).map do |mac|
       data = {
        unit:mac.unit,
        date:date,
        :machine_id=>mac.id,
        :machine_name=>mac.machine_name,
        :alarm=>mac.alarms.last,
        :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
        :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
        :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
        :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
       }
      end
    else
      if shift != []
          
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
        
        tenant.machines.where.not(controller_type: [3]).order(:id).map do |mac|
          machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
         
         if mac.cnc_reports.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).present?
          data1 = mac.cnc_reports.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).last
             data = {
              :unit => mac.unit,
              :start_time=>start_time,
              :shift_no =>shift.shift_no,
              :machine_id=>mac.id,
              :machine_name=>mac.machine_name,
              :utilization=>data1.utilization,
              :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
             }
         else
             total_shift_time_available_for_downtime =  Time.now - start_time
             run_time = Machine.run_time(machine_log)
             utilization = (run_time*100)/duration if duration.present?     
         
          data = {
            :unit => mac.unit,
            :date =>date,
            :start_time=>start_time,
            :shift_no =>shift.shift_no,
            :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
            :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
            :machine_id=>mac.id,
            :machine_name=>mac.machine_name,
            :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
            :utilization=>utilization
          }
         end
         
        end
      else
        data = { message:"No shift Currently Avaliable" }
      end
    end
  end
end

def self.machine_process100(params)
  tenant = Tenant.find(params[:tenant_id])
  mac = Machine.find(params[:machine_id])
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != nil
    case
    when shift.day == 1 && shift.end_day == 1   
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time  
    when shift.day == 1 && shift.end_day == 2
      # start_time = (date+" "+shift.shift_start_time).to_time
      # end_time = (date+" "+shift.shift_end_time).to_time+1.day
      if Time.now.strftime("%p") == "AM"
        start_time = (date+" "+shift.shift_start_time).to_time-1.day
        end_time = (date+" "+shift.shift_end_time).to_time
      else
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time+1.day
      end
    else
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time     
    end
  
  

  else
    data = { message:"No shift Currently Avaliable" }
  end
end


def self.machine_process(params)   # This Method used particular machines Full Detail of Current Shift
  tenant = Tenant.find(params[:tenant_id])
  mac = Machine.find(params[:machine_id])
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != []
    date = Date.today.to_s

    if tenant.id != 10
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
        
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
        end

        # start_time = (date+" "+shift.shift_start_time).to_time
        # end_time = (date+" "+shift.shift_end_time).to_time+1.day    
      else
        start_time = (date+" "+shift.shift_start_time).to_time+1.day
        end_time = (date+" "+shift.shift_end_time).to_time+1.day     
      end
    end
    
    machine_log1 = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    
    if mac.cnc_reports.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).present?
     # byebug
      data1 = mac.cnc_reports.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).last
      if data1.all_cycle_time.present?
        cycle_time = data1.all_cycle_time.last[:cycle_time].to_i
      else
        cycle_time = 0
      end
      
      if data1.stop_time.to_i > data1.run_time.to_i && data1.stop_time.to_i > data1.idle_time.to_i
        stop = data1.stop_time.to_i + data1.time_diff.to_i
      else
       stop = data1.stop_time.to_i
      end

      if data1.idle_time.to_i >= data1.run_time.to_i && data1.idle_time.to_i >= data1.stop_time.to_i
        idle = data1.idle_time.to_i + data1.time_diff.to_i
      else
        idle = data1.idle_time.to_i
      end
      
      if data1.run_time.to_i > data1.idle_time.to_i && data1.run_time.to_i > data1.stop_time.to_i
        run = data1.run_time.to_i + data1.time_diff.to_i
      else
        run = data1.run_time.to_i
      end  
     # byebug
      if machine_log1.last.present?
        controller_part = machine_log1.last.parts_count.to_i 
      else
        controller_part = 0
      end 
      
      new_parst_count = data1.all_cycle_time.count
      
      job_wise_part = []
      data1.all_cycle_time

      data = {
      :cycle_time=> cycle_time.present? ? Time.at(cycle_time).utc.strftime("%H:%M:%S") : "00:00:00", # Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
      :total_run_time=>run != nil ? Time.at(run).utc.strftime("%H:%M:%S") : "00:00:00",
      :idle_time=> idle != nil ?  idle > 0 ? Time.at(idle).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :total_stop_time=> stop != nil ? stop > 0 ? Time.at(stop).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :shift_no =>shift.shift_no, 
      :day_start=>machine_log1.first.present? ? machine_log1.first.created_at.in_time_zone("Chennai") : 0,
      :last_update=>machine_log1.last.present? ? machine_log1.order(:id).last.created_at.in_time_zone("Chennai") : 0,
      :machine_id=>mac.id,
      :machine_name=>mac.machine_name,
      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
      :parts_count=>new_parst_count,
      :downtime=> idle != nil ?  idle > 0 ? Time.at(idle).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :machine_status=>machine_log1.last.present? ? (Time.now - machine_log1.last.created_at) > 600 ? nil : machine_log1.last.machine_status : nil,
      :utilization=>data1.utilization.round(),
      :controller_part=>controller_part,
      #:job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
      :start_time=>start_time
    }


    else
   
    #end
    


    job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
    duration = end_time.to_i - start_time.to_i
    new_parst_count = Machine.new_parst_count(machine_log1)
    run_time = Machine.run_time(machine_log1)
    stop_time = Machine.stop_time(machine_log1)
    ideal_time = Machine.ideal_time(machine_log1)
    
    if mac.controller_type == 2
      cycle_time = Machine.rs232_cycle_time(machine_log1) 
    else
      cycle_time = Machine.cycle_time(machine_log1)
    end

    if mac.controller_type == 2 
      if machine_log1.last.present?
        if machine_log1.last.parts_count.to_i == 0
          controller_part = 0
        else
          controller_part = machine_log1.last.parts_count.to_i + 1
        end
      else
        controller_part = 0
      end
    else
      if machine_log1.last.present?
        controller_part = machine_log1.last.parts_count.to_i 
      else
        controller_part = 0
      end 
    end
    
    count = machine_log1.count
    time_diff = duration - (run_time+stop_time+ideal_time)
    utilization = (run_time*100)/duration if duration.present?

    data = {
      :cycle_time=> cycle_time.present? ? Time.at(cycle_time.last[:cycle_time]).utc.strftime("%H:%M:%S") : "00:00:00", # Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
      :total_run_time=>run_time != nil ? Time.at(run_time).utc.strftime("%H:%M:%S") : "00:00:00",
      :idle_time=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :total_stop_time=> stop_time != nil ? stop_time > 0 ? Time.at(stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :shift_no =>shift.shift_no, 
      :day_start=>machine_log1.first.present? ? machine_log1.first.created_at.in_time_zone("Chennai") : 0,
      :last_update=>machine_log1.last.present? ? machine_log1.order(:id).last.created_at.in_time_zone("Chennai") : 0,
      :machine_id=>mac.id,
      :machine_name=>mac.machine_name,
      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
      :parts_count=>new_parst_count,
      :downtime=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :machine_status=>machine_log1.last.present? ? (Time.now - machine_log1.last.created_at) > 600 ? nil : machine_log1.last.machine_status : nil,
      :utilization=>utilization.round(),
      :controller_part=>controller_part,
      #:job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
      :start_time=>start_time
    }
  end


  else
    data = { message:"No shift Currently Avaliable" }
  end

end


def self.rs232_machine_process(params)
	#byebug
  tenant = Tenant.find(params[:tenant_id])
  mac = Machine.find(params[:machine_id])
  shift = Shifttransaction.current_shift(tenant.id)
  if shift != []
    date = Date.today.to_s

    #if tenant.id != 10
      # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
      #   if Time.now.strftime("%p") == "AM"
      #     date = (Date.today - 1).strftime("%Y-%m-%d")
      #   end 
      #   start_time = (date+" "+shift.shift_start_time).to_time
      #   end_time = (date+" "+shift.shift_end_time).to_time+1.day                       
      # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")                
      #   if Time.now.strftime("%p") == "AM"
      #     date = (Date.today - 1).strftime("%Y-%m-%d")
      #   end
      #     start_time = (date+" "+shift.shift_start_time).to_time+1.day
      #     end_time = (date+" "+shift.shift_end_time).to_time+1.day
      # else
      #   start_time = (date+" "+shift.shift_start_time).to_time
      #   end_time = (date+" "+shift.shift_end_time).to_time        
      # end
    #else
       case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time  
      when shift.day == 1 && shift.end_day == 2   
        
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
        end

        # start_time = (date+" "+shift.shift_start_time).to_time
        # end_time = (date+" "+shift.shift_end_time).to_time+1.day    
      else
        start_time = (date+" "+shift.shift_start_time).to_time+1.day
        end_time = (date+" "+shift.shift_end_time).to_time+1.day     
      end
    #end
   machine_log1 = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
   job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
    duration = end_time.to_i - start_time.to_i
    new_parst_count = Machine.new_parst_count(machine_log1)
    run_time = Machine.run_time(machine_log1)
    stop_time = Machine.stop_time(machine_log1)
    ideal_time = Machine.ideal_time(machine_log1)
    
    if mac.controller_type == 2
      cycle_time = Machine.rs232_cycle_time(machine_log1) 
    else
      cycle_time = Machine.cycle_time(machine_log1)
    end

    if mac.controller_type == 2 
      if machine_log1.last.present?
        if machine_log1.last.parts_count.to_i == 0
          controller_part = 0
        else
          controller_part = machine_log1.last.parts_count.to_i + 1
        end
      else
        controller_part = 0
      end
    else
      if machine_log1.last.present?
        controller_part = machine_log1.last.parts_count.to_i 
      else
        controller_part = 0
      end 
    end
    
    count = machine_log1.count
    time_diff = duration - (run_time+stop_time+ideal_time)
    utilization = (run_time*100)/duration if duration.present?

    data = {
      :start_time => start_time,
      :cycle_time=> cycle_time.present? ? Time.at(cycle_time.last[:cycle_time]).utc.strftime("%H:%M:%S") : "00:00:00", # Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
      :total_run_time=>run_time != nil ? Time.at(run_time).utc.strftime("%H:%M:%S") : "00:00:00",
      :idle_time=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :total_stop_time=> stop_time != nil ? stop_time > 0 ? Time.at(stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :shift_no =>shift.shift_no, 
      :day_start=>machine_log1.first.present? ? machine_log1.first.created_at.in_time_zone("Chennai") : 0,
      :last_update=>machine_log1.last.present? ? machine_log1.order(:id).last.created_at.in_time_zone("Chennai") : 0,
      :machine_id=>mac.id,
      :machine_name=>mac.machine_name,
      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
      :parts_count=>new_parst_count,
      :downtime=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
      :machine_status=>machine_log1.last.present? ? (Time.now - machine_log1.last.created_at) > 600 ? nil : machine_log1.last.machine_status : nil,
      :utilization=>utilization.round(),
      :controller_part=>controller_part,
      #:job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
      :start_time=>start_time
    }
  #end


  else
    data = { message:"No shift Currently Avaliable" }
  end


end



#----------------------------------------------------

def self.dashboard_process(params) #The Big View of Dashboard

  date = Date.today.strftime("%Y-%m-%d")
  tenant = Tenant.find(params[:tenant_id])
  machines = tenant.machines.where.not(controller_type: [3,4])
  shift = Shifttransaction.current_shift(tenant.id)
 
  if tenant.id != 1
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
      start_time = shift.shift_start_time.to_time
      end_time = shift.shift_end_time.to_time
    when shift.day == 1 && shift.end_day == 2
      
      if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
        end



      # start_time = shift.shift_start_time.to_time
      # end_time = shift.shift_end_time.to_time+1.day     
    else
      start_time = shift.shift_start_time.to_time+1.day
      end_time = shift.shift_end_time.to_time+1.day     
    end
  end

   
  machines.order(:id).map do |mac|
    machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)     
    #job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
    duration = end_time.to_i - start_time.to_i
    new_parst_count = Machine.new_parst_count(machine_log1)
    run_time = Machine.run_time(machine_log1)
    stop_time = Machine.stop_time(machine_log1)
    ideal_time = Machine.ideal_time(machine_log1)
    
    if mac.controller_type == 2
      cycle_time = Machine.rs232_cycle_time(machine_log1) 
    else
      cycle_time = Machine.cycle_time(machine_log1)
    end
    
    if mac.controller_type == 2 
      if machine_log1.last.present?
        if machine_log1.last.parts_count.to_i == 0
          controller_part = 0
        else
          controller_part = machine_log1.last.parts_count.to_i + 1
        end
      else
        controller_part = 0
      end
    else
      if machine_log1.last.present?
        controller_part = machine_log1.last.parts_count.to_i 
      else
        controller_part = 0
      end 
    end

    #start_cycle_time = Machine.start_cycle_time(machine_log1)
    count = machine_log1.count
    time_diff = duration - (run_time+stop_time+ideal_time)
    utilization = (run_time*100)/duration if duration.present?
 





   #------------------ Start -------------------------- #

    if machine_log1.present?
    if machine_log1.where(machine_status: 3).present?
        data = machine_log1.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
        
        if data.count == 1
          cutting_time = 0
          spindle_load = machine_log1.last.spindle_load
        else
          cutting_time = (machine_log1.where(parts_count: data[-2][1]).last.total_cutting_time.to_i * 60 + machine_log1.where(parts_count: data[-2][1]).last.total_cutting_second.to_i/1000) - (machine_log1.where(parts_count: data[-2][1]).first.total_cutting_time.to_i * 60 + machine_log1.where(parts_count: data[-2][1]).first.total_cutting_second.to_i/1000)
          spindle_load = machine_log1.last.spindle_load
        end
        job_wise_parts = data.group_by{|x|x[0]}.map{|k,v| [k,v.size]}.to_h
        feed_rate = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.last
        spindle_speed = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.last
      else
        job_wise_parts = 0
        cutting_time = 0
        spindle_load = machine_log1.last.spindle_load
        feed_rate = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.last
        spindle_speed = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.last
        
      end
    sp_temp = machine_log1.last.z_axis
   else
       cutting_time = 0
        spindle_load = 0
        feed_rate = 0
        spindle_speed = 0
        job_wise_parts = 0
        sp_temp = 0
        job_wise_parts = 0
    end

   #------------------ end -----------------------------#













 
    data = {
          :feed_rate => feed_rate.present? ? feed_rate : 0,
          :spindle_load => spindle_load.present? ?  spindle_load : 0,
          :spindle_speed => spindle_speed.present? ? spindle_speed : 0,
          :sp_temp => sp_temp,
          :cutting_time => cutting_time.present? ? Time.at(cutting_time).utc.strftime("%H:%M:%S") : "00:00:00",
          :job_wise_parts => job_wise_parts.present? ? job_wise_parts : 0,

          :unit=>mac.unit,
          :cycle_time=> cycle_time.present? ? Time.at(cycle_time.last[:cycle_time]).utc.strftime("%H:%M:%S") : "00:00:00", # Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
          :total_run_time=>run_time != nil ? Time.at(run_time).utc.strftime("%H:%M:%S") : "00:00:00",
          :idle_time=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
          :total_stop_time=> stop_time != nil ? stop_time > 0 ? Time.at(stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
          :shift_no =>shift.shift_no,
          :day_start=>machine_log1.first.present? ? machine_log1.first.created_at.in_time_zone("Chennai") : 0,
          :last_update=>machine_log1.last.present? ? machine_log1.order(:id).last.created_at.in_time_zone("Chennai") : 0,
          :machine_id=>mac.id,
          :machine_name=>mac.machine_name,
          :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
          :parts_count=>new_parst_count,
          :downtime=> ideal_time != nil ?  ideal_time > 0 ? Time.at(ideal_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
          :machine_status=>machine_log1.last.present? ? (Time.now - machine_log1.last.created_at) > 600 ? nil : machine_log1.last.machine_status : nil,
          :utilization=>utilization.round(),
          :controller_part=>controller_part,
          :start_time=>start_time
          }
  end   
end
  #--------------------------------------------------------------------------

def self.dashboard_process1(params)  # Used Big
  # byebug
    tenant=Tenant.find(1)#(params[:tenant_id])
    if tenant.machines !=[] 
      
    shift = Shifttransaction.current_shift(tenant.id)
    if shift != nil
    #date = Date.today.strftime("%Y-%m-%d")
     date = Date.today.to_s
          
              if params[:type] == "Alarm"
                 tenant.machines.order(:id).map do |mac|
               data = {
                unit:mac.unit,
                date:date,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
                :alarm=>mac.alarms.last,
                :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
                :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
                :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
                :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
               }
            end
         else
          if shift != []
          
          

          # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
          #   if Time.now.strftime("%p") == "AM"
          #     date = (Date.today - 1).strftime("%Y-%m-%d")
          #   end 
          #   start_time = (date+" "+shift.shift_start_time).to_time
          #   end_time = (date +" "+shift.shift_end_time).to_time + 1.day
          # else
          #   start_time = (date+" "+shift.shift_start_time).to_time
          #   end_time = (date+" "+shift.shift_end_time).to_time 
          # end


          total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
          actual_working_time = Time.now - shift.shift_start_time.to_time
             tenant.machines.order(:id).map do |mac|
                machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
                total_shift_time_available_for_downtime =  Time.now - start_time

                unless machine_log.present?
                 downtime = 0
                else
                 
                   parts_count = Machine.parts_count_calculation(machine_log)
                   total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
                   
                   total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model 
                   
                   if mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).present? 
                    entry_data_run_time = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:run_time).sum
                    total_run_time = total_run_time + entry_data_run_time
                    entry_parts = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:parts_produced).sum
                    parts_count = parts_count + entry_parts.to_i
                   end
                  
                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name| 
                    if machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.count > 1
                      job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                       part_split_job = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).split("0")
                          part_count_job=[]
                        part_split_job.uniq.map do |part|
                    unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split_job[0].empty?
                              part_count_job << part[-1].to_i
                           else 
                             part_count_job << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count_job << part[-1].to_i
                        end
                      elsif part_split_job.index(part) != 0 && part[0] != machine_log.first.parts_count
                          part_count_job << part[0].to_i
                      end
                     end
                    end
                      else
                        part_count_job = 0
                      end
                    else
                     part_count_job = [parts_count] 
                    end

                     part_count_job = part_count_job.select(&0.method(:<)).sum < 0 ? 0 : part_count_job.select(&0.method(:<)).sum
                    parts_count_splitup << {:job_name=>j_name,:part_count=>part_count_job}
                   end
                   
                    all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                    total_load_unload_time=[]
                    all_jobs.map do |job|
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                    job_part_load_unload.shift if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1  
                      
                    job_wise_load_unload = machine_log.where(parts_count:job_part).where(programe_number:job).group_by(&:parts_count).map{|pp,qq| qq.last.run_time.nil? ? 0 : (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                        total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                   end
                   
                   total_load_unload_time = total_load_unload_time.sum
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60

                   downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                  end
                
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  utilization = utilization.nil? ? 0 : utilization
                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                  #machine_log.where(machine_status:"100").map do |stop|
                    
                 # end
                  #stop_time= 

# for runtime and stop time

  all_machine_details = {}
  data = {}
  all_machine_details[:machine_status_report] = []
  data[:time_difference] = []
  data[:time_difference_seconds] = []
  final_data=[];
    unless machine_log.count == 0
      final = []
      frst = machine_log[0].machine_status
      machine_log.map do |ll|
        if ll.machine_status == frst
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          final << "$$"
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
          frst = ll.machine_status
        end
      end

      aa = final.split("$$")
      bb=[]
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}
      rr.map do |ll|
        all_machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}
      end
      all_machine_details[:machine_status_report].map do |data|
         data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
         data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
      end
      @total_stop_time_all = all_machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum
      all_machine_details[:machine_status_report].clear
           end       #total_stop_time= (@stop_time.count) * 1
      controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
      parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
      parts_last = (controller_part.to_i )
      downtime1 = (downtime != nil && @total_stop_time != nil) ? (downtime > 0 && @total_stop_time > 0 ) ? downtime - @total_stop_time : 0 : 0
#
  #  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
  #   # parts_count = parts_count.to_i < 0 ? controller_part : parts_count.to_i
  #   parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
  #   parts_last = (controller_part.to_i)
     #parts_last = controller_part.to_i < 0 ? 0 : (controller_part.to_i - 1)
                
                data = {
                      unit:mac.unit,
                      :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                      :total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      :idle_time=> idle_time != nil ?  idle_time > 0 ? Time.at(idle_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :total_stop_time=> @total_stop_time != nil ? @total_stop_time_all > 0 ? Time.at(@total_stop_time_all).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :downtime=> downtime1 !=nil ? downtime1 > 0 ? Time.at(downtime1).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",

                      #:total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      #:total_stop_time=> @total_stop_time != nil ? @total_stop_time > 0 ? Time.at(@total_stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      #:cycle_time=> parts_count.to_i > 0 ? machine_log.where(:parts_count=>machine_log.last.parts_count - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count ).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0,         
                      #:idle_time=> idle_time != nil ?  idle_time > 0 ? Time.at(idle_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                     
                      #:cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                     # :total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                     # :idle_time=>Time.at(idle_time).utc.strftime("%H:%M:%S"),
                     #:total_stop_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      :shift_no =>shift.shift_no,
                      :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
                      :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                      :machine_id=>mac.id,
                      :machine_name=>mac.machine_name,
                      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? "O"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
                      :parts_count=>parts_count,
                      :downtime=> Time.at(downtime).utc.strftime("%H:%M:%S"),
                      :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                      :utilization=>utilization.round(),
                      :spindle_speed=>machine_log.last.present? ? machine_log.last.spindle_speed : nil,
                      :spindle_load=>machine_log.last.present? ? machine_log.last.spindle_load : nil,
                      :feed_rate=>machine_log.last.present? ? machine_log.last.feed_rate : nil,
                      :cutting_time=>cutting_time,
                      :total_load_unload_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                      :controller_part=>controller_part,
                      :report_from=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai").strftime("%d/%m/%Y %I:%M %p") : nil,
                      :job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
                      :entry_alert => mac.data_loss_entries.where("created_at >?",start_time).present? ? true : false,
                      :start_time=>start_time
                    }
                    
      end
    
       else
         data = { message:"No shift Currently Avaliable" }
      end
      end
    end
  end
  end


  def self.consolidate_data
    s_time = Time.now - 15.minutes
    e_time = Time.now
   # byebug
     Tenant.where(isactive:true).map do |tenant|
      shift = Shifttransaction.current_shift(tenant.id)
      #byebug
      if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        #byebug
        if Time.now.strftime('%p') == "AM"
         # byebug
          start_time = shift.shift_start_time.to_time - 1.day
        else
         # byebug
          start_time = shift.shift_start_time.to_time 
        end
        #byebug
         end_time = shift.shift_end_time.to_time + 1.day
      else
        #byebug
         start_time = shift.shift_start_time.to_time
         end_time = shift.shift_end_time.to_time 
      end

        tenant.machines.map do |mac|
          #byebug
           machine_log = mac.machine_daily_logs.where("created_at >? AND created_at <?",s_time,e_time)
           # machine_log = mac.machine_daily_logs.where("created_at >? AND created_at <?","09:00 AM".to_time,"11:00 AM".to_time)

                   unless machine_log.empty?
                    shift_data = machine_log.where("created_at >?","09:00 AM")
                    shift_data.order(:id).map do |ff|
                       # byebug
                    if mac.consolidate_data.count != 0

                      last_cons_data = mac.consolidate_data.order(:id).last
                        if last_cons_data.shift == shift.shift_no
                          
                              if ff.parts_count == "-1" || last_cons_data.parts_count == -1
                                cons_parts_count = last_cons_data.cons_parts_count
                                else
                                cons_parts_count = ff.parts_count.to_i >= last_cons_data.parts_count.to_i ? (ff.parts_count.to_i - last_cons_data.parts_count.to_i)  + last_cons_data.cons_parts_count : ff.parts_count.to_i + last_cons_data.cons_parts_count
                                  #ConsolidateDatum.create(parts_count:ff.parts_count,cons_parts_count:last_cons_data.parts_count, programe_number:ff.programe_number, machine_status:ff.machine_status, day:ff.created_at.localtime.strftime("%d"), month:ff.created_at.localtime.strftime("%m"), year: ff.created_at.localtime.strftime("%y"), shift:shift.shift_no, total_run_time:ff.total_run_time, cons_tot_run_time:last_cons_data., total_run_second:0, cons_tot_run_second:0, cutting_time:0, cons_cutting_time:0, cycle_time:last_cons_data., run_time: ff.run_time, cons_run_time:last_cons_data.run_time, run_second:ff.run_second, cons_run_second:last_cons_data.run_second, machine_id:mac.id)   
                              end
                                  if last_cons_data.total_run_time == 0
                                    cons_total_run_time = last_cons_data.cons_total_run_time
                                  else
                                    cons_total_run_time = ff.total_run_time >= last_cons_data.total_run_time ? (ff.total_run_time - last_cons_data.total_run_time) + last_cons_data.cons_total_run_time : ff.total_run_time + last_cons_data.cons_total_run_time
                                  end
                           cons_total_run_second = ff.total_run_second >= last_cons_data.total_run_second ? (ff.total_run_second - last_cons_data.total_run_second) + last_cons_data.cons_total_run_second : ff.total_run_second + last_cons_data.cons_total_run_second
                             cons_run_time = ff.run_time*60# >= last_cons_data.run_time/60 ? (ff.run_time - last_cons_data.run_time)*60 + last_cons_data.cons_run_time : (ff.run_time*60) + last_cons_data.cons_run_time
                           cons_run_second = 0 # ff.run_second >= last_cons_data.run_second ? (ff.run_second - last_cons_data.run_second) + last_cons_data.cons_run_second : ff.run_second + last_cons_data.cons_run_second
                           if last_cons_data.cutting_time == 0
                            cons_cutting_time = last_cons_data.cons_cutting_time
                           else
                           cons_cutting_time = ff.total_cutting_time >= last_cons_data.cutting_time ? (ff.total_cutting_time - last_cons_data.cutting_time) + last_cons_data.cons_cutting_time : ff.total_cutting_time + last_cons_data.cons_cutting_time
                            end           
                            
                               if (last_cons_data.parts_count == ff.parts_count.to_i)
                                  if ff.parts_count != "-1"
                                    cycle_time = last_cons_data.cycle_time + (ff.created_at - last_cons_data.log_created_time)
                                  else
                                    cycle_time = last_cons_data.cycle_time
                                  end
                                 load_unload_time = nil
                               else
                                 if last_cons_data.cons_parts_count != 0 
                                  
                                   last_cons_data.update(cons_run_time:last_cons_data.run_time+last_cons_data.run_second/1000)
                                   last_cons_data.update(cons_load_unload_time:last_cons_data.cycle_time - last_cons_data.cons_run_time)
                                 end

                                 cycle_time = 0
                               end
                             time_available = ff.created_at - start_time   
                                 # =>  if ConsolidateDatum.count > 150
                             aa = ConsolidateDatum.create!(parts_count:ff.parts_count,cons_parts_count:cons_parts_count,programe_number:ff.programe_number,machine_status:ff.machine_status,day:ff.created_at.localtime.strftime("%d"), month:ff.created_at.localtime.strftime("%m"), year: ff.created_at.localtime.strftime("%y"), shift:shift.shift_no,total_run_time:ff.total_run_time,cons_total_run_time:cons_total_run_time,total_run_second:ff.total_run_second,cons_total_run_second:cons_total_run_second,run_time:ff.run_time*60,cons_run_time:cons_run_time,run_second:ff.run_second,cons_run_second:cons_run_second,cutting_time:ff.total_cutting_time,cons_cutting_time:cons_cutting_time,machine_id:mac.id,cycle_time:cycle_time,cons_down_time:((ff.created_at-start_time)-(last_cons_data.cons_total_run_time*60)),log_created_time:ff.created_at,total_available_time:time_available)
                        else
                          start = ConsolidateDatum.create(parts_count: ff.parts_count,cons_parts_count:0, programe_number:ff.programe_number, machine_status:ff.machine_status, day:ff.created_at.localtime.strftime("%d"), month:ff.created_at.localtime.strftime("%m"), year: ff.created_at.localtime.strftime("%y"), shift:shift.shift_no, total_run_time:ff.total_run_time, cons_total_run_time:0, total_run_second:ff.total_run_second, cons_total_run_second:0, cutting_time:ff.total_cutting_time, cons_cutting_time:0, cycle_time:0, run_time: ff.run_time*60, cons_run_time:0, run_second:ff.run_second, cons_run_second:0, machine_id:mac.id,cons_down_time:(ff.created_at-start_time),log_created_time:ff.created_at,total_available_time:0)

                        end
                    else
                      frst = ConsolidateDatum.create(parts_count: ff.parts_count,cons_parts_count:0, programe_number:ff.programe_number, machine_status:ff.machine_status, day:ff.created_at.localtime.strftime("%d"), month:ff.created_at.localtime.strftime("%m"), year: ff.created_at.localtime.strftime("%y"), shift:shift.shift_no, total_run_time:ff.total_run_time, cons_total_run_time:0, total_run_second:ff.total_run_second, cons_total_run_second:0, cutting_time:ff.total_cutting_time, cons_cutting_time:0, cycle_time:0, run_time: ff.run_time*60, cons_run_time:0, run_second:ff.run_second, cons_run_second:0, machine_id:mac.id,cons_down_time:(ff.created_at-start_time),log_created_time:ff.created_at,total_available_time:0)
                    end
                   end
                end
        end
     end
  end

  def self.delete_data
    #MachineDailyLog.where("created_at <?",Date.today-1).delete_all
    MachineDailyLog.where("created_at <?",Date.yesterday.beginning_of_day - 1.day).delete_all
  end

   def self.data_loss_entry
                Tenant.where(isactive:true).map do |tenant|
             #   Tenant.where(id:[121]).map do |tenant|
                  shift = Shifttransaction.current_shift(tenant.id)
                    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
                      if Time.now.strftime('%p') == "AM"
                        start_time = shift.shift_start_time.to_time - 1.day
                      else
                        start_time = shift.shift_start_time.to_time 
                      end
                       end_time = shift.shift_end_time.to_time + 1.day
                    else
                       start_time = shift.shift_start_time.to_time
                       end_time = shift.shift_end_time.to_time 
                    end


                    tenant.machines.map do |machine|
                      machine_log = machine.machine_daily_logs.where(created_at: start_time..Time.now).order(:id)
                if machine_log.count != 0
                    machine_log.map do |data|
                        if machine_log.last != data
                          if machine_log.index(data) == 0 && ((data.created_at - start_time) > 900)
                                  if machine.data_loss_entries.where(start_time:start_time).present?
                                     if !machine.data_loss_entries.where(start_time:start_time,end_time:data.created_at,entry_status:false).present?
                                      machine.data_loss_entries.where(start_time:start_time,end_time:data.created_at)[0].update(end_time:data.created_at)
                                     else
                                      DataLossEntry.create(start_time:machine.data_loss_entries.where(start_time:start_time)[0].end_time,end_time:data.created_at,machine_id:machine.id,entry_status:false,total_second:data.created_at-machine.data_loss_entries.where(start_time:start_time)[0].end_time)
                                     end
                                   else
                                     if (data.created_at - start_time) >= 900
                                      DataLossEntry.create(:start_time=>start_time.utc,end_time:data.created_at,machine_id:machine.id,entry_status:0,total_second:data.created_at-start_time)
                                     end
                                   end          
                          elsif (machine_log[machine_log.index(data)+1].created_at - data.created_at) >= 900
                                  if machine.data_loss_entries.where(start_time:data.created_at).present?
                                       if !machine.data_loss_entries.where(start_time:data.created_at,end_time:machine_log[machine_log.index(data)+1].created_at,entry_status:false).present?
                                        machine.data_loss_entries.where(start_time:data.created_at,end_time:machine_log[machine_log.index(data)+1].created_at)[0].update(end_time:machine_log[machine_log.index(data)+1].created_at,total_second:machine_log[machine_log.index(data)+1].created_at)[0].update(end_time:machine_log[machine_log.index(data)+1].created_at-data.created_at)
                                       else
                                         DataLossEntry.create(start_time:machine.data_loss_entries.where(start_time:data.created_at)[0].end_time,end_time:data.created_at,machine_id:machine.id,entry_status:false,total_second:data.created_at-machine.data_loss_entries.where(start_time:data.created_at)[0].end_time)
                                       end
                                   else
                                    if (machine_log[machine_log.index(data)+1].created_at - data.created_at) >= 900
                                       DataLossEntry.create(:start_time=>data.created_at,end_time:machine_log[machine_log.index(data)+1].created_at,machine_id:machine.id,entry_status:false,total_second:machine_log[machine_log.index(data)+1].created_at-data.created_at)
                                    end                        
                                   end          
                          end

                        end
                    end
                else
                  machine.data_loss_entries.where(start_time:start_time).present? ? machine.data_loss_entries.where(start_time:start_time).update(end_time:Time.now.utc) : DataLossEntry.create(:start_time=>start_time.utc,end_time:Time.now.utc,machine_id:machine.id,entry_status:0,total_second:Time.now-start_time)
                           #          DataLossEntry.create(:start_time=>start_time.utc,end_time:Time.now.utc,machine_id:machine.id,entry_status:0,total_second:Time.now-start_time)
                end
          end
        end
      end

def self.target_parts(params)
  
     machine = Machine.find params[:machine_id]
     params[:shifttransaction_id].to_i == 0 ? nil : params[:shifttransaction_id]
     shifts = params[:shifttransaction_id].present? ? Shifttransaction.where(id:params[:shifttransaction_id]) : machine.tenant.shift.shifttransactions  
     date = params[:date].present? ? params[:date] : Date.today.to_s
     total_time = params[:shifttransaction_id].present? ? (date+" "+Shifttransaction.find(params[:shifttransaction_id]).shift_end_time).to_time - (date+" "+Shifttransaction.find(params[:shifttransaction_id]).shift_start_time).to_time : 86400
     percentage = params[:hour].present? ? total_time / ((date+" "+params[:hour].split("-")[1]).to_time - (date+" "+params[:hour].split("-")[0]).to_time) : 1
     parts_count=[]
     target_parts = []
     total_load_unload_time=[]
     parts_count_splitup=[]
      shifts.map do |shift| 
      if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      else
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time 
      end
       time_range = start_time..end_time
       
       if params[:date].present? ? params[:date] : Date.today.to_s
       total_data = machine.machine_daily_logs.where(created_at: start_time..end_time).order(:id)
     else
       total_data = machine.machine_logs.where(created_at: start_time..end_time).order(:id)
     end
     if params[:hour].present?
       target_time = (date+" "+params[:hour].split("-")[1]).to_time - (date+" "+params[:hour].split("-")[0]).to_time 
       if params[:date].present? ? params[:date] : Date.today.to_s
       total_part_data = machine.machine_daily_logs.where(created_at: (date+" "+params[:hour].split("-")[0]).to_time..(date+" "+params[:hour].split("-")[1]).to_time ).order(:id)      
     else
        total_part_data = machine.machine_daily_logs.where(created_at: (date+" "+params[:hour].split("-")[0]).to_time..(date+" "+params[:hour].split("-")[1]).to_time ).order(:id)      
      end
       part_count=[]
                  part_split = total_part_data.where.not(parts_count:"-1").pluck(:parts_count).split("0")
                    part_split.uniq.map do |part|
                   unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split[0].empty?
                              part_count << part[-1].to_i
                           else 
                             part_count << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count << part[-1].to_i
                        end
                      elsif part_split.index(part) != 0 && part[0] != total_part_data.first.parts_count
                          part_count << part[0].to_i
                      end
                     end
                    end
        parts_count << part_count.sum
     else
       target_time = end_time - start_time
      
            part_count=[]
                  part_split = total_data.where.not(parts_count:"-1").pluck(:parts_count).split("0")
                    part_split.uniq.map do |part|
                   unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split[0].empty?
                              part_count << part[-1].to_i
                           else 
                             part_count << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count << part[-1].to_i
                        end
                      elsif part_split.index(part) != 0 && part[0] != total_data.first.parts_count
                          part_count << part[0].to_i
                      end
                     end
                    end
        parts_count << part_count.sum
     end

    jobs = total_data.pluck(:programe_number).uniq.reject{|ff| ff == "" || ff.nil?}
                   total_data.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name| 
                   job_name = "O"+j_name
                      if total_data.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                       part_split_job = total_data.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).split("0")
                          part_count_job=[]
                        part_split_job.uniq.map do |part|
                    unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split_job[0].empty?
                              part_count_job << part[-1].to_i
                           else 
                             part_count_job << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count_job << part[-1].to_i
                        end
                     elsif part_split_job.index(part) != 0 && part[0] != total_data.first.parts_count
                          part_count_job << part[0].to_i
                      end
                     end
                    end
                      else
                        part_count_job = 0
                      end
                     part_count_job = part_count_job.select(&0.method(:<)).sum < 0 ? 0 : part_count_job.select(&0.method(:<)).sum
                    parts_count_splitup << {:job_name=>job_name,:part_count=>part_count_job}
                   end
                   total_time = []
    jobs.map do |job|
      job_wise_load_unload = []
      job_wise_cycle_time = []
      job_part = total_data.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
      job_part_total = total_data.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq#for get total data between the job
      job_part_load_unload = total_data.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
      job_part_load_unload.shift if job_part_load_unload[0] == "0" || job_part_load_unload[0] == total_data.first.parts_count
      job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
      job_part.shift
      job_part.pop if job_part.count > 1  
      #job_wise_load_unload = total_data.where(parts_count:job_part_total).where(programe_number:job).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}                
      
    #  job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
        unless job_wise_cycle_time.min.nil?

          #total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
          job_wise_cycle_time = job_wise_cycle_time.count > 2 ? job_wise_cycle_time.sort[1] : job_wise_cycle_time.min
          time = (total_data.where(parts_count:job_part_total).where(programe_number:job).order(:id).last.created_at - total_data.where(parts_count:job_part_total).where(programe_number:job).order(:id).first.created_at)
          total_time << time
          target_parts << time/job_wise_cycle_time
          parts_count_splitup.select{|i| i[:job_name] == "O"+job}[0][:fastest_cycle_time] = Time.at(job_wise_cycle_time).utc.strftime("%H:%M:%S")
        end
    end

 end
 
    data = {
      :total_time => (total_time.sum/60).round(),
      :acived_parts => parts_count.sum > 0 ? parts_count : 0,
      :targer_parts => (target_parts.sum/percentage).round(),
      :parts_split => parts_count_splitup,
      #:efficiency => ((target_parts.sum/percentage) - parts_count.sum).round() < 0 ||  parts_count.sum > 0 ?  ((parts_count.sum / (target_parts.sum/percentage) )*100).round() : 0 
      :efficiency =>((target_parts.sum/percentage) - (parts_count.sum > 0 ? parts_count.sum : 0)).round() < 0 ||  parts_count.sum <= 0 ? 0 : (((parts_count.sum > 0 ? parts_count : 0) / (target_parts.sum/percentage) )*100).round()
    }
    

 end

   def self.time_line_report_calculation
       date = Date.today.to_s
       record_date = Date.today - 1.day
       Tenant.where(isactive:true).map do |tenant|
       if tenant.shift.day_start_time.to_time <= Time.now 
         tenant.machines.map do |machine|
            machine_log = machine.machine_daily_logs.where("created_at >? AND created_at <?",tenant.shift.day_start_time.to_time - 1.day,tenant.shift.day_start_time.to_time)
          tenant.shift.shifttransactions.map do |shift|
            if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
               start_time = (record_date.to_s+" "+shift.shift_start_time).to_time
               end_time = (record_date.to_s+" "+shift.shift_end_time).to_time + 1.day
            else
               start_time = (record_date.to_s+" "+shift.shift_start_time).to_time
               end_time = (record_date.to_s+" "+shift.shift_end_time).to_time 
            end
             time_range = start_time..end_time
             total_data = machine_log.where(created_at: start_time..end_time).order(:id)
             machine_details = {}
              machine_details[:machine_status_report] = []
              machine_details[:downtime] = []
              machine_details[:production] = []
              machine_details[:job_details] = {}
              machine_details[:data_status] = total_data.empty? ? false : true
             
                machine_details[:job_details][:parts_produced] = total_data.where.not(parts_count:"-1").present? ? total_data.where.not(parts_count:"-1").pluck(:parts_count).uniq.reject{|i| i == "0"}.count : 0
                machine_details[:job_details][:rejects] = 0
                machine_details[:job_details][:rework] = 0
                machine_details[:job_details][:inspection] = 0
                machine_details[:job_details][:remaining_parts] = 0
                machine_details[:job_details][:parts_delivered] = 0

              bb=[];kk=[];
              hourinterval = []
              (start_time.to_i..end_time.to_i).step(3600){|pp| hourinterval << Time.at(pp).localtime}
              final_data=[];
              
              unless total_data.count == 0
                final = []
                frst = total_data[0].machine_status
                total_data.map do |ll|
                  if ll.machine_status == frst
                    final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
                  else
                    final << "$$"
                    final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
                    frst = ll.machine_status
                  end
                end
                aa = final.split("$$")
                aa.map {|ss| bb << [ss[0],ss[-1]]}
                rr = bb.map{|ll| ll.flatten}
                  
                rr.map{|ll| machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}}

                machine_details[:machine_status_report].map do |data|
                   data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
                   data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
                end
                total_run_time = Machine.calculate_total_run_time(total_data)
                stop_time = machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum
                idle_time = ((end_time-start_time)-total_run_time)-stop_time
                shift_timeline_report = ShiftTimelineReport.create(date:record_date,run_time:total_run_time,stop_time:stop_time,ideal_time:idle_time,machine_id:machine.id,shifttransaction_id:shift.id)
                MachineDailyLog.hour_time_line_report(start_time,end_time,shift_timeline_report.id,machine.id)
              end
          end 

         end
       end
    end
 end

 def self.hour_time_line_report(start_time,end_time,shift_timeline_report_id,machine_id)
   
        machine = Machine.find(machine_id)
        machine_log = machine.machine_daily_logs.where(created_at: start_time..end_time).order(:id)
        hour_split=[]
       (start_time.to_i..end_time.to_i).step(3600){|pp| hour_split << Time.at(pp).localtime}
       hour_split.map do |hour|
        
       total_data = machine_log.where(created_at: hour..hour+1.hour).order(:id)
       unless total_data.count == 0
       final = []
       frst = total_data[0].machine_status
       bb = [] 
         total_data.map do |ll|
           if ll.machine_status == frst
              final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status]
           else
             final << "$$"
             final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status]
             frst = ll.machine_status
           end
         end

       aa = final.split("$$")
       aa.map {|ss| bb << [ss[0],ss[-1]]}
       rr = bb.map{|ll| ll.flatten}
       total_run_time = Machine.calculate_total_run_time(total_data)
        stop_time = rr.select{|kk| kk[1] == "100"}.map{|ff| ff[2].to_time - ff[0].to_time}.sum

       hour_timeline_report = HourTimelineReport.create(start_time:hour,end_time:hour+1.hour,ideal_time:(3600-total_run_time)-stop_time,run_time:total_run_time,stop_time:stop_time,shift_timeline_report_id:shift_timeline_report_id)
       MachineDailyLog.hour_detail_report(hour_timeline_report.id,hour,hour+1.hour,machine.id)      
      end
    end
     end


  def self.hour_detail_report(hour_timeline_report_id,start_time,end_time,machine_id)
        
        machine = Machine.find(machine_id)
    total_hour_data = machine.machine_daily_logs.where("created_at >? AND created_at <?",start_time,end_time).order(:id)
    #total_run_chart = total_hour_data.pluck(:total_run_time).uniq.reject{|ff| ff == 0}.count*60
    #data_loss_stop_hour =total_hour_data.count != 0 ?  ((total_hour_data[0].created_at - start_time)+(end_time - total_hour_data.last.created_at)) : 0   #for data loss between start_time and end time
    #total_idel_chart = 3600 - (total_run_chart+data_loss_stop_hour)
    #total_stop_chart = [] 
   hour_split = []
   (start_time.to_i..end_time.to_i).step(600){|pp| hour_split << Time.at(pp).localtime}
   hour_split.map do |minute|
    bb=[]
  total_data = machine.machine_daily_logs.where("created_at >? AND created_at <?",minute,minute+10.minutes).order(:id)
  unless total_data.count == 0
      final = []
      frst = total_data[0].machine_status

      total_data.map do |ll|
        if ll.machine_status == frst
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          final << "$$"

          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
          frst = ll.machine_status
        end
      end
      
      aa = final.split("$$")
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}
      machine_status_report=[]
      rr.map{|ll| machine_status_report << {:start_time=>ll[0].to_time.strftime("%I:%M:%S %p"),:end_time=>ll[4].to_time.strftime("%I:%M:%S %p"),:status=>ll[1],:time_difference=>Time.at(ll[4].to_time-ll[0].to_time).utc.strftime("%M:%S")}}

      total_run_time = Machine.calculate_total_run_time(total_data)
      total_stop_time = rr.select{|ss| ss[1] == "100"}.map{|ss| ss[4].to_time-ss[0].to_time}.sum if !rr[0].nil?
      total_idle_time = (600 - total_run_time) - (total_stop_time)
      HourDetailTimelineReport.create(start_time:minute,end_time:minute+10.minutes,ideal_time:total_idle_time,stop_time:total_stop_time,run_time:total_run_time,hour_timeline_report_id:hour_timeline_report_id) unless minute+10.minute > end_time
     end
   end
 end



  def self.dashboard_status1(params) # used
   tenant=Tenant.find(params[:tenant_id])
   shift = Shifttransaction.current_shift(tenant.id)
   if shift != nil
   date = Date.today.to_s
   
   if params[:type] == "Alarm"
    tenant.machines.order(:id).map do |mac|
               data ={
                unit:mac.unit,
                date:date,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
                :alarm=>mac.alarms.last,
                :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
                :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
                :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
                :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
               }
            end
         else
               if shift != []
               if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
                 if Time.now.strftime("%p") == "AM"
                    date = Date.today - 1
                 end 
                start_time = (date+" "+shift.shift_start_time).to_time
                end_time = (date +" "+shift.shift_end_time).to_time + 1.day

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
               
                total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
                actual_working_time = Time.now - shift.shift_start_time.to_time
                tenant.machines.order(:id).map do |mac| 
                machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
                total_shift_time_available_for_downtime =  Time.now - start_time
                tot_run_time = Machine.calculate_total_run_time(machine_log)
                utilization =(tot_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                utilization = utilization.nil? ? 0 : utilization.round()
             
               data = {
                unit:mac.unit,
                date:date,
                :start_time=>start_time,
                :shift_no =>shift.shift_no,
                :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
                :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
                :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                :utilization=>utilization
              }
             end

             
      else
         data = { message:"No shift Currently Avaliable" }
      end
    end
  end
end







def self.machine_process1(params)   # Used

    tenant=Tenant.find(params[:tenant_id])
    mac=Machine.find(params[:machine_id])
    shift = Shifttransaction.current_shift(tenant.id)
     if shift != []
    

    date = Date.today.to_s
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        if Time.now.strftime("%p") == "AM"
          date = Date.today - 1
        end 
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date +" "+shift.shift_end_time).to_time + 1.day
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
          

    total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
    actual_working_time = Time.now - shift.shift_start_time.to_time           
    machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    total_shift_time_available_for_downtime =  Time.now - start_time

   
    unless machine_log.present?
      downtime = 0
    else         
      parts_count = Machine.parts_count_calculation(machine_log)
      total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
      total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model 

                   # if mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).present? 
                   #  entry_data_run_time = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:run_time).sum
                   #  total_run_time = total_run_time + entry_data_run_time
                   #  entry_parts = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:parts_produced).sum
                   #  parts_count = parts_count + entry_parts.to_i
                   # end

                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name| 
                    if machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.count > 1
                      job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                       part_split_job = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).split("0")
                          part_count_job=[]
                        part_split_job.uniq.map do |part|
                    unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split_job[0].empty?
                              part_count_job << part[-1].to_i
                           else 
                             part_count_job << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count_job << part[-1].to_i
                        end
                      elsif part_split_job.index(part) != 0 && part[0] != machine_log.first.parts_count
                          part_count_job << part[0].to_i
                      end
                     end
                    end
                      else
                        part_count_job = 0
                      end
                    else
                     part_count_job = [parts_count] 
                    end
                     part_count_job = part_count_job.select(&0.method(:<)).sum < 0 ? 0 : part_count_job.select(&0.method(:<)).sum
                    parts_count_splitup << {:job_name=>j_name,:part_count=>part_count_job}
                   end
                   
                    all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                    total_load_unload_time=[]
                    all_jobs.map do |job|
                      
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                    
                    job_part_load_unload.shift if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    
                    job_part.shift
                    
                    job_part.pop if job_part.count > 1  
                    job_wise_load_unload = machine_log.where(parts_count:job_part).where(programe_number:job).group_by(&:parts_count).map{|pp,qq| qq.last.run_time.nil? ? 0 : (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                        total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                   end
                   total_load_unload_time = total_load_unload_time.sum
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60

                   downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                  end
                
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  utilization = utilization.nil? ? 0 : utilization
                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                   machine_details = {}
                   data = {}
                  machine_details[:machine_status_report] = []
                  data[:time_difference] = []
               data[:time_difference_seconds] = []
               #   machine_log.where(machine_status:"100").map do |stop|
                    
               #     @stop_time << stop.created_at
               #   end

                  final_data=[];
    unless machine_log.count == 0
      final = []
      frst = machine_log[0].machine_status
      machine_log.map do |ll|
        if ll.machine_status == frst
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          final << "$$"
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
          frst = ll.machine_status
        end
      end

      aa = final.split("$$")
      bb=[]
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}
      rr.map do |ll|
        machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}
      end

      machine_details[:machine_status_report].map do |data|
         data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
         data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
      end
      @total_stop_time = machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum
      #byebug
      machine_details[:machine_status_report].clear
           end       #total_stop_time= (@stop_time.count) * 1
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                  
                  parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                  parts_last = (controller_part.to_i )
                   downtime1 = (downtime != nil && @total_stop_time != nil) ? (downtime > 0 && @total_stop_time > 0 ) ? downtime - @total_stop_time : 0 : 0
                   # downtime1 = downtime - @total_stop_time
                     data = {
                      :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                      :total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      :idle_time=> idle_time != nil ?  idle_time > 0 ? Time.at(idle_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :total_stop_time=> @total_stop_time != nil ? @total_stop_time > 0 ? Time.at(@total_stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :shift_no =>shift.shift_no,
                      :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
                      :last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                      :machine_id=>mac.id,
                      :machine_name=>mac.machine_name,
                      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? "O"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
                      :parts_count=>parts_count,
                      :downtime=> downtime1 !=nil ? downtime1 > 0 ? Time.at(downtime1).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                      :utilization=>utilization.round(),
                      :total_load_unload_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                      :controller_part=>controller_part,
                      :job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
                      :start_time=>start_time
                    }
      else
         data = { message:"No shift Currently Avaliable" }
      end


end







def self.toratex112(params)  
   machine = Machine.find_by(machine_ip: params["machine_ip"])
   if machine != nil
   tenant = machine.tenant
   shift = Shifttransaction.current_shift(tenant.id)
   if shift != []
    date = Date.today.to_s
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
    machine_log = machine.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    parts_count = Machine.new_parsts_count(machine_log)
    total_run_time = Machine.calculate_total_run_time(machine_log)
    machine_status = machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil
    if shift.operator_allocations.where(machine_id: machine.id).last.nil?
       operator_id = nil
       operator_name = "Operator Not Assigned"
       target = pending = rework = approved = reject = 0
       reason = "Not Entered"
       alert = "Not Available"
      else
       if shift.operator_allocations.where(machine_id: machine.id).present?
         shift.operator_allocations.where(machine_id: machine.id).each do |ro|
         aa = ro.from_date
         bb = ro.to_date
         cc = date
        if cc.to_date.between?(aa.to_date,bb.to_date)  
         dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
         data = dd.operator_mapping_allocations.where(:date=>date.to_date).last
         if data.operator.present?
           operator_id = data.operator.id
           operator_name =  Operator.find(data.operator_id).operator_name
           target = data.target == nil ? 0 : data.target
           pending = (target - parts_count) < 0 ? 0 : (target - parts_count)
           rework = data.rework  == nil ? 0 : data.rework
           approved = data.approved == nil ? 0 : data.approved
           reject = data.rejected == nil ? 0 : data.rejected
           reason = data.reason == nil ? "Not Entered" : data.reason
           alert = data.alert == nil ? "Not Available" : data.alert
         else
           operator_id = nil
           operator_name = "Operator Not Assigned"
           target = pending = rework = approved = reject = 0
           reason = "Not Entered"
           alert = "Not Available"
         end              
        end
       end
       else
           operator_id = nil
           operator_name = "Operator Not Assigned"
           target = pending = rework = approved = reject = 0
           reason = "Not Entered"
           alert = "Not Available"
    end
   end
  end
    return {total_run_time: total_run_time, machine_name: machine.machine_name,machine_status: machine_status,parts_count: parts_count, operator_name: operator_name,target: target,pending: pending,rework: rework,approved: approved,rejected: reject,shift_no: shift.shift_no,start_time: shift.shift_start_time, temperature: 0, reason: reason, alart: alert }
 else
    return "Machine Not Registered" 
 end
end




  def self.toratex23456(params)
  mac = Machine.find_by(machine_ip: params["machine_ip"])    
  if mac != nil
    tenant = mac.tenant
    date = Date.today.strftime("%Y-%m-%d")
    tenant = Tenant.find(tenant.id)
    shift = Shifttransaction.current_shift(tenant.id)
    case
    when shift.day == 1 && shift.end_day == 1
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time
    when shift.day == 1 && shift.end_day == 2
      if Time.now.strftime("%p") == "AM"
        start_time = (date+" "+shift.shift_start_time).to_time-1.day
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")##
      else
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time+1.day
      end
    when shift.day == 2 && shift.end_day == 2
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time
    end
    
    duration = end_time.to_i - start_time.to_i
    machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    machine_status = machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil
    parts_count1 = Machine.new_parsts_count(machine_log)
    tot_run = Machine.calculate_total_run_time(machine_log)
    tot_stop = Machine.stop_time(machine_log)
    tot_idle = Machine.ideal_time(machine_log)
    reason = mac.machine_setting.reason
    utilization = (tot_run*100)/duration

    balance_time = end_time.to_i - Time.now.to_i
    tot_diff = duration - (balance_time + tot_run + tot_idle + tot_stop)

    if tot_stop.to_i > tot_run.to_i && tot_stop.to_i > tot_idle.to_i
     total_stop_time = (tot_stop.to_i + tot_diff.to_i)
    else
     total_stop_time = (tot_stop.to_i)
    end
    
    if tot_idle.to_i >= tot_run.to_i && tot_idle.to_i >= tot_stop.to_i
       total_idle_time = (tot_idle.to_i + tot_diff.to_i)
    else
       total_idle_time = (tot_idle.to_i)
    end
    
    if tot_run.to_i > tot_idle.to_i && tot_run.to_i > tot_stop.to_i
      total_run_time = (tot_run.to_i + tot_diff.to_i)
    else
      total_run_time = (tot_run.to_i)
    end
 
   if shift.operator_allocations.where(machine_id:mac.id).last.nil?
        operator_id = nil
        operator_name = 'Operator Not Entered'
        target = 0
      else
        if shift.operator_allocations.where(machine_id:mac.id).present?
        shift.operator_allocations.where(machine_id:mac.id).each do |ro| 
          aa = ro.from_date
          bb = ro.to_date
          cc = date
          if cc.to_date.between?(aa.to_date,bb.to_date)  
          dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
          if dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.present?
            operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id
            operator_name = Operator.find(operator_id).operator_name
            target = dd.operator_mapping_allocations.where(:date=>date.to_date).last.target
          else
            operator_id = nil
            operator_name = 'Operator Not Entered'
            target = 0
          end 
          else
             operator_id = nil
             operator_name = 'Operator Not Entered'
             target = 0         
          end
        end
        else
          operator_id = nil
          operator_name = 'Operator Not Entered'
          target = 0
        end
      end

       data = ShiftPart.where(date: date, machine_id:mac.id, shift_no: shift.shift_no)
       parts_count = data.count
       approved = data.where(status: 1).count
       rework = data.where(status: 2).count
       rejected = data.where(status: 3).count
       
       if target == 0
         pending = 0
         efficiency = 0
       else
         pending = target - parts_count
         efficiency1 = parts_count/target.to_f
         eff = efficiency1*100
         efficiency = eff.to_i
       end
      return {utilization: utilization, efficiency: efficiency, total_run_time: Time.at(total_run_time).utc.strftime('%H:%M:%S'), total_idle_time:  Time.at(total_idle_time  ).utc.strftime('%H:%M:%S'), total_stop_time:  Time.at(total_stop_time).utc.strftime('%H:%M:%S'),  machine_name: mac.machine_name,machine_status: machine_status,parts_count: parts_count, operator_name: operator_name,target: target,pending: pending,rework: rework,approved: approved,rejected: rejected,shift_no: shift.shift_no,start_time: shift.shift_start_time, temperature: 1, reason: reason, time: Time.now.loacltime}
  else
    return "Machine Not Registered" 
  end
end








  def self.toratex(params)
  mac = Machine.find_by(machine_ip: params["machine_ip"])
  if mac != nil
    tenant = mac.tenant
    date = Date.today.strftime("%Y-%m-%d")
    tenant = Tenant.find(tenant.id)
    shift = Shifttransaction.current_shift(tenant.id)
    case
    when shift.day == 1 && shift.end_day == 1
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time
    when shift.day == 1 && shift.end_day == 2
      if Time.now.strftime("%p") == "AM"
        start_time = (date+" "+shift.shift_start_time).to_time-1.day
        end_time = (date+" "+shift.shift_end_time).to_time

       date = (Date.today - 1.day).strftime("%Y-%m-%d") ##
      else
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time+1.day
      end
    when shift.day == 2 && shift.end_day == 2
      start_time = (date+" "+shift.shift_start_time).to_time
      end_time = (date+" "+shift.shift_end_time).to_time
    end

    duration = end_time.to_i - start_time.to_i
    machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    machine_status = machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil
    parts_count1 = Machine.new_parsts_count(machine_log)
    tot_run = Machine.calculate_total_run_time(machine_log)
    tot_stop = Machine.stop_time(machine_log)
    tot_idle = Machine.ideal_time(machine_log)
    reason = mac.machine_setting.reason
    utilization = (tot_run*100)/duration

        balance_time = end_time.to_i - Time.now.to_i
    tot_diff = duration - (balance_time + tot_run + tot_idle + tot_stop)

    if tot_stop.to_i > tot_run.to_i && tot_stop.to_i > tot_idle.to_i
     total_stop_time = (tot_stop.to_i + tot_diff.to_i)
    else
     total_stop_time = (tot_stop.to_i)
    end

    if tot_idle.to_i >= tot_run.to_i && tot_idle.to_i >= tot_stop.to_i
       total_idle_time = (tot_idle.to_i + tot_diff.to_i)
    else
       total_idle_time = (tot_idle.to_i)
    end

    if tot_run.to_i > tot_idle.to_i && tot_run.to_i > tot_stop.to_i
      total_run_time = (tot_run.to_i + tot_diff.to_i)
    else
      total_run_time = (tot_run.to_i)
    end

   if shift.operator_allocations.where(machine_id:mac.id).last.nil?
        operator_id = nil
        operator_name = 'Operator Not Entered'
        target = 0
      else
        if shift.operator_allocations.where(machine_id:mac.id).present?
        shift.operator_allocations.where(machine_id:mac.id).each do |ro|
          aa = ro.from_date
          bb = ro.to_date
          cc = date
          if cc.to_date.between?(aa.to_date,bb.to_date)
          dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
          if dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.present?
            operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id
            operator_name = Operator.find(operator_id).operator_name
            target = dd.operator_mapping_allocations.where(:date=>date.to_date).last.target
          else
            operator_id = nil
            operator_name = 'Operator Not Entered'
            target = 0
          end

          else
             operator_id = nil
             operator_name = 'Operator Not Entered'
             target = 0
          end
        end
        else
          operator_id = nil
          operator_name = 'Operator Not Entered'
          target = 0
        end
      end

       data = ShiftPart.where(date: date, machine_id:mac.id, shift_no: shift.shift_no)
       parts_count = data.count
       approved = data.where(status: 1).count
       rework = data.where(status: 2).count
       rejected = data.where(status: 3).count

       if target == 0
         pending = 0
         efficiency = 0
       else
         pending = target - parts_count
         efficiency1 = parts_count/target.to_f
         eff = efficiency1*100
         efficiency = eff.to_i
       end
      return {utilization: utilization, efficiency: efficiency, total_run_time: Time.at(total_run_time).utc.strftime('%H:%M:%S'), total_idle_time:  Time.at(total_idle_time  ).utc.strftime('%H:%M:%S'), total_stop_time:  Time.at(total_stop_time).utc.strftime('%H:%M:%S'),  machine_name: mac.machine_name,machine_status: machine_status,parts_count: parts_count, operator_name: operator_name,target: target,pending: pending,rework: rework,approved: approved,rejected: rejected,shift_no: shift.shift_no,start_time: shift.shift_start_time, temperature: 1, reason: reason, time: Time.now.strftime("%I:%M %p"), date: Time.now.strftime("%d-%m-%Y")}
  else
    return "Machine Not Registered"
  end
end


























end






