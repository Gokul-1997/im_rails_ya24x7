class CtMachineDailyLog < ApplicationRecord
  belongs_to :machine



  def self.ct_dashboard(params)  
    shift = Shifttransaction.current_shift(params[:tenant_id])
    tenant = Tenant.find(params[:tenant_id])
    machines = tenant.machines.where(controller_type: 3)
    date = Date.today.strftime("%Y-%m-%d")
    

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
    #   start_time = (date+" "+shift.shift_start_time).to_time+1.day
    #   end_time = (date+" "+shift.shift_end_time).to_time+1.day
    # else           
    #   start_time = (date+" "+shift.shift_start_time).to_time
    #   end_time = (date+" "+shift.shift_end_time).to_time        
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
    machines.all.map do |mac|
      machine = mac.ct_machine_daily_logs.where(from_date: start_time..end_time)
      @s=[]
      @i=[]
      @r=[]
      # Below condition check machine status 
      # 0 - Stoptime
      # 1 - idletime
      # 3 - Runningtime
            
      machine.where(status:0).order(:id).each do |stop|
        @s<<(stop.to_date - stop.from_date)
        #@s<<(stop.created_at.to_time)
      end
        current_stop_time=@s.sum
          
      machine.where(status:1).order(:id).each do |idle|
        @i<<(idle.to_date - idle.from_date)
        # @i<<(idle.created_at.to_time)
      end
        current_down_time=@i.sum
          
      machine.where(status:3).order(:id).each do |run|
        @r<<(run.to_date - run.from_date)
        #@r<<(run.created_at.to_time)
      end
        current_run_time=@r.sum
  

      #-----------------------------------------
      shift_time_available = end_time.to_i - start_time.to_i #Time.parse(shift.duration).seconds_since_midnight #shift available time calculation
      #shift_time_available = Time.parse(end_time - start_time).seconds_since_midnight
      total_shift_time_available = ((shift_time_available/60).round())*60
      utilization =(current_run_time*100)/total_shift_time_available # utilization calculation
      utilization = utilization.nil? ? 0 : utilization
      total=current_stop_time + current_down_time + current_run_time
         
	    data = {
	     :unit=>mac.unit,
	     :date=>Date.today,
	     :start_time=>start_time,
	     :shift_no=>shift.shift_no,
	     :first_update=>machine.first.present? ? machine.first.from_date : 0,
	     :last_update=>machine.last.present? ? machine.last.to_date : mac.ct_machine_logs.last.present? ?  mac.ct_machine_logs.last.to_date : 0,
	     #:last_update=>machines.last.present? ? machines.last.to_date : 0,
	     :machine_name=>mac.machine_name,
	     #:status=>machine.machine_logs.last.present? ? (machine.machine_logs.last.updated_at).localtime.strftime("%Y-%m-%d %H:%M:%S") == Time.now.localtime.strftime("%Y-%m-%d %H:%M:%S") ? machine.machine_logs.last.status : 0 : 0,
	     :status=>machine.last.present? ? (Time.now - machine.last.to_date) > 600 ? "false" : machine.last.status : nil,
	     :utilization=>utilization.nil? || utilization < 0 ? 0 : utilization.round(),
	     :stoptime=>Time.at(current_stop_time).utc.strftime("%H:%M:%S"),
	     :idletime=>Time.at(current_down_time).utc.strftime("%H:%M:%S"),
	     :runtime=> Time.at(current_run_time).utc.strftime("%H:%M:%S"),
	     #:uptime=>machine.machine_logs.last.uptime,
	     :total=>Time.at(total).utc.strftime("%H:%M:%S")
	      #.strftime("%D %I:%M %P"),
	    }      
    end
  end
  
  def self.ct_machine_reports
    @data=[]
    tenants = Tenant.where(id: [3])
    tenants.each do |tenant|
    date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.current_shift(tenant.id) # this method refer to Shift Method 
    #shift start & end time checking calculation
       
    
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
    #   start_time = (date+" "+shift.shift_start_time).to_time+1.day
    #   end_time = (date+" "+shift.shift_end_time).to_time+1.day
    # else           
    #   start_time = (date+" "+shift.shift_start_time).to_time
    #   end_time = (date+" "+shift.shift_end_time).to_time        
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
    tenant.machines.where(controller_type: 3).map do |machine|       
      machines = machine.ct_machine_daily_logs.where(from_date: start_time..end_time)
      @s=[]
      @i=[]
      @r=[]
      
      machines.where(status:0).order(:id).each do |stop|
        @s<<(stop.to_date - stop.from_date)
      end
        current_stop_time=@s.sum
      
      machines.where(status:1).order(:id).each do |idle|
        @i<<(idle.to_date - idle.from_date)
      end
        current_down_time=@i.sum
      
      machines.where(status:3).order(:id).each do |run|
        @r<<(run.to_date - run.from_date)
      end
        current_run_time=@r.sum
      
      #-----------------------------------------
      
      shift_id = shift.shift.id
      shift_time_available = end_time.to_i - start_time.to_i #shift available time calculation
      total_shift_time_available = ((shift_time_available/60).round())*60
      utilization =(current_run_time*100)/total_shift_time_available # utilization calculation
      utilization = utilization.nil? ? 0 : utilization
      operator_id = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:machine.id).last.operator_mappings.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mappings.where(:date=>date.to_date).last.operator.id : nil  
      total=current_stop_time + current_down_time + current_run_time
      @data << [date,shift.shift_no,shift.shift_start_time+' - '+shift.shift_end_time,shift_id,operator_id,machine.id,Time.at(current_run_time).utc.strftime("%H:%M:%S"),Time.at(current_down_time).utc.strftime("%H:%M:%S"),Time.at(current_stop_time).utc.strftime("%H:%M:%S"),Time.at(total).utc.strftime("%H:%M:%S"),shift.actual_working_hours,utilization.nil? || utilization < 0 ? 0 : utilization.round(), tenant.id]
    end    
    end
    
    @data.map do |data|
      if CtReport.where(date:data[0],shift_no: data[1],machine_id:data[5]).present?
        CtReport.find_by(date:data[0],shift_no: data[1],machine_id:data[5]).update(time: data[2], shift_id: data[3], operator_id: data[4], run_time: data[6], idle_time: data[7], stop_time: data[8], total_time: data[9], actual_shifttime: data[10], utilization: data[11], tenant_id: data[12])
      else
        if CtReport.where(machine_id:data[5]).last.present?
          last_shift_report = CtReport.where(machine_id:data[5]).last
          #report_id = CtReport.where(machine_id:data[5]).last.id
         # shift_data = CtMachineDailyLog.last_shift_report(report_id)
          #last_shift_report.update(program_number: shift_data[5], job_description: shift_data[6], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], utilization: shift_data[15])
          #last_shift_report.update(time: shift_data[2], shift_id: shift_data[3], operator_id: shift_data[4], run_time: shift_data[6], idle_time: shift_data[7], stop_time: shift_data[8], total_time: shift_data[9], actual_shifttime: shift_data[10], utilization: shift_data[11])
        end 
       # byebug   
        CtReport.create!(date: data[0], shift_no: data[1], time: data[2], shift_id: data[3], operator_id: data[4], machine_id: data[5], run_time: data[6], idle_time: data[7], stop_time: data[8], total_time: data[9], actual_shifttime: data[10], utilization: data[11], tenant_id: data[12])                      
      end
    end
  end

  def self.last_shift_report(data)
    @data = []
      


    machine_id = machine_id
    report_data = CtReport.where(machine_id: machine_id).last
    time= report_data.time.split("-")
    start_time1 = time[0]
    end_time1 = time[1]
    date=report_data.date
    machine = Machine.find_by_id(machine_id)
    shift = Shift.find_by_id(report_data.shift_id)   
    start_time = (date.strftime("%Y-%m-%d")+" "+start_time1).to_time
    end_time = (date.strftime("%Y-%m-%d")+" "+end_time1).to_time        
     
         end_time_for_ideal =end_time
         # total_shift_time_available = Time.parse(report_data.actual_working_hours).seconds_since_midnight
          machines = machine.machine_logs.where(from_date: start_time..end_time)
           
           @s=[]
           @i=[]
           @r=[]

             


             machines.where(status:0).order(:id).each do |stop|
              @s<<(stop.to_date - stop.from_date)
             end
             current_stop_time=@s.sum
            
             machines.where(status:1).order(:id).each do |idle|
             @i<<(idle.to_date - idle.from_date)
             end
             current_down_time=@i.sum
            
             machines.where(status:3).order(:id).each do |run|
              @r<<(run.to_date - run.from_date)
             end
             current_run_time=@r.sum

           #-----------------------------------------
            
            shift_time_available = Time.parse(shift.duration).seconds_since_midnight #shift available time calculation
            total_shift_time_available = ((shift_time_available/60).round())*60
            utilization =(current_run_time*100)/total_shift_time_available # utilization calculation
            utilization = utilization.nil? ? 0 : utilization
            operator_id = shift.operator_allocations.where(machine_id:machine.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:machine.id).last.operator_mappings.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine.id).last.operator_mappings.where(:date=>date.to_date).last.operator.id : nil  
            total=current_stop_time + current_down_time + current_run_time
            @data << [ date,shift.shift_no,shift.start_time.strftime("%I:%M %p")+' - '+shift.end_time.strftime("%I:%M %p"),shift.id,operator_id,machine.id,Time.at(current_run_time).utc.strftime("%H:%M:%S"),Time.at(current_down_time).utc.strftime("%H:%M:%S"),Time.at(current_stop_time).utc.strftime("%H:%M:%S"),Time.at(total).utc.strftime("%H:%M:%S"),shift.duration,utilization.nil? || utilization < 0 ? 0 : utilization.round()]
  end
end
