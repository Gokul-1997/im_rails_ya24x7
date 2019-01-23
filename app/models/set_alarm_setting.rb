class SetAlarmSetting < ApplicationRecord
  belongs_to :machine, -> { with_deleted }


  def self.pre_setting_dasboard(params)
  	date = Date.today.strftime("%Y-%m-%d")
  	tenant = Tenant.find(params[:tenant_id])
    shift = Shifttransaction.current_shift(params[:tenant_id])    
    if shift != []
      case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time 
         date = Date.today.strftime("%Y-%m-%d") 
      when shift.day == 1 && shift.end_day == 2
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
          date = (Date.today - 1.day).strftime("%Y-%m-%d")
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
          date = Date.today.strftime("%Y-%m-%d")
        end  
      when shift.day == 2 && shift.end_day == 2
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")      
      end

      duration = end_time.to_i - start_time.to_i
      tenant.machines.where(controller_type: 1).order(:id).map do |mac| 
	      machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
	    
	      if mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).present? &&  params[:status] == "1"
        # byebug
           data1 = mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).last
           data = {
           	:unit => mac.unit,
           	:date =>date,
           	:start_time=>start_time,
	          :shift_no =>shift.shift_no,
	          :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
	          #:last_update=>machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
	          :last_update=>machine_log.last.present? ? data1.updated_at.in_time_zone("Chennai") : 0,
	          :machine_id=>mac.id,
	          :machine_name=>mac.machine_name,
	          :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
	          :utilization=>data1.utilization,
	          :pre_data=> true
            
           }
        else

	      run_time = Machine.calculate_total_run_time(machine_log)
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
	        :utilization=>utilization,
	        :pre_data=> false
	      }
	    end



      end
    else
      data = { message:"No shift Currently Avaliable" }
    end
  end


  def self.pre_setting_dasboard_full_data(params)	
  	date = Date.today.strftime("%Y-%m-%d")
  	tenant = Tenant.find(params[:tenant_id])
    shift = Shifttransaction.current_shift(params[:tenant_id])    
    if shift != []
      case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time 
         date = Date.today.strftime("%Y-%m-%d") 
      when shift.day == 1 && shift.end_day == 2
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
          date = (Date.today - 1.day).strftime("%Y-%m-%d")
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
          date = Date.today.strftime("%Y-%m-%d")
        end  
      when shift.day == 2 && shift.end_day == 2
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")      
      end
  end
   duration = end_time.to_i - start_time.to_i
   tenant.machines.where(controller_type: 1).order(:id).map do |mac| 
	   machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
	   
	   if mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).present?  &&  params[:status] == "1"
	      data1 = mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).last
	      data = {
	      	:unit => mac.unit,
	      	:machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
	        :date =>date,
	        :machine_id => mac.id,
	        :utilization=>data1.utilization,
	        :start_time => machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
	        :last_update => data1.updated_at.localtime,
	        :machine_name => mac.machine_name,
	        :job_id => data1.job_id,
	        :machine_disply => machine_log.last.present? ? machine_log.last.machine_status.to_i : nil,
	        :parts_count => data1.machine_status,
	        :job_wise_part => data1.job_wise_part,
	        :cycle_time => Time.at(data1.cycle_time.to_i).utc.strftime("%H:%M:%S"),
	        :run_time => data1.run_time,
	        :idle_time => data1.idle_time,
	        :stop_time => data1.stop_time,
	        :pre_data=> true
	      }
	   else
	   tot_run = Machine.calculate_total_run_time(machine_log)
     tot_stop = Machine.stop_time(machine_log)
	   tot_idle = Machine.ideal_time(machine_log)
	   count = machine_log.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
      #machine_log.where(machine_status: 3)
      job_id = machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil
      
       shift_wise_part = []
       if machine_log.present? && machine_log.where(machine_status: 3).present?
       machine_log.where(machine_status: 3).group_by{|d| d[:programe_number]}.map do |k, v|
       	 cc = v.pluck(:parts_count).uniq.count
         shift_wise_part << { program_number: k, parts_count: cc }
       end
        end

      if count.present?
        total_count = count.count - 1
        
        unless count.count == 1
          data = count[-2]
          data2 = machine_log.where(programe_number: data[0], parts_count: data[1]).last
          cycle_time = data2.run_time * 60 + data2.run_second.to_i/1000
        else
          data = count[-1]
          cycle_time = 0
        end
      else
      	cycle_time = 0
      	total_count = 0
      end
      utilization = (tot_run*100)/duration
      balance_time = end_time.to_i - Time.now.to_i
      tot_diff = duration - (balance_time + tot_run + tot_idle + tot_stop)
      
      if tot_stop.to_i > tot_run.to_i && tot_stop.to_i > tot_idle.to_i
        total_stop_time = Time.at(tot_stop.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
        total_stop_time = Time.at(tot_stop.to_i).utc.strftime("%H:%M:%S")
      end
      
      if tot_idle.to_i >= tot_run.to_i && tot_idle.to_i >= tot_stop.to_i
         total_idle_time = Time.at(tot_idle.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
         total_idle_time = Time.at(tot_idle.to_i).utc.strftime("%H:%M:%S")
      end
      
      if tot_run.to_i > tot_idle.to_i && tot_run.to_i > tot_stop.to_i
        total_run_time = Time.at(tot_run.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
        total_run_time = Time.at(tot_run.to_i).utc.strftime("%H:%M:%S")
      end
      data = {
      	:unit => mac.unit,
      	:machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
        :date =>date,
        :machine_id => mac.id,
        :utilization=>utilization,
        :start_time => machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
        :last_update => machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
        :machine_name => mac.machine_name,
        :job_id => job_id,
        :machine_disply => machine_log.last.present? ? machine_log.last.machine_status.to_i : nil,
        :parts_count => total_count,
        :job_wise_part => shift_wise_part,
        :cycle_time => Time.at(cycle_time.to_i).utc.strftime("%H:%M:%S"),
        :run_time => total_run_time,
        :idle_time => total_idle_time,
        :stop_time => total_stop_time,
        :pre_data=> false
	      }
    end
	end
  end

  def self.single_machine_pre_data(params)  
    mac = Machine.find(params[:machine_id])
  	tenant = mac.tenant
  	date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.current_shift(tenant.id)    
    if shift != []
      case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time 
         date = Date.today.strftime("%Y-%m-%d") 
      when shift.day == 1 && shift.end_day == 2
        if Time.now.strftime("%p") == "AM"
          start_time = (date+" "+shift.shift_start_time).to_time-1.day
          end_time = (date+" "+shift.shift_end_time).to_time
          date = (Date.today - 1.day).strftime("%Y-%m-%d")
        else
          start_time = (date+" "+shift.shift_start_time).to_time
          end_time = (date+" "+shift.shift_end_time).to_time+1.day
          date = Date.today.strftime("%Y-%m-%d")
        end  
      when shift.day == 2 && shift.end_day == 2
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time
        date = (Date.today - 1.day).strftime("%Y-%m-%d")      
      end
    
     duration = end_time.to_i - start_time.to_i
     machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id) 
	   if mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).present?  &&  params[:status] == "1"
	      data1 = mac.dashboard_data.where(date: date, machine_id: mac.id, shift_no: shift.shift_no).last
	      data = {
	      	:unit => mac.unit,
	      	:machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
	        :date =>date,
	        :machine_id => mac.id,
	        :utilization=>data1.utilization,
	        :start_time => machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
	        :last_update => data1.updated_at.localtime,
	        :machine_name => mac.machine_name,
	        :job_id => data1.job_id,
	        :machine_disply => machine_log.last.present? ? machine_log.last.machine_status.to_i : nil,
	        :parts_count => data1.machine_status,
	        :job_wise_part => data1.job_wise_part,
	        :cycle_time => Time.at(data1.cycle_time.to_i).utc.strftime("%H:%M:%S"),
	        :run_time => data1.run_time,
	        :idle_time => data1.idle_time,
	        :stop_time => data1.stop_time,
	        :pre_data=> true
	      }
	   else
	   tot_run = Machine.calculate_total_run_time(machine_log)
     tot_stop = Machine.stop_time(machine_log)
	   tot_idle = Machine.ideal_time(machine_log)
	   count = machine_log.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
      #machine_log.where(machine_status: 3)
      job_id = machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil
       
       shift_wise_part = []
       if machine_log.present? && machine_log.where(machine_status: 3).present?
       machine_log.where(machine_status: 3).group_by{|d| d[:programe_number]}.map do |k, v|
       	 cc = v.pluck(:parts_count).uniq.count
         shift_wise_part << { program_number: k, parts_count: cc }
       end
      end

      if count.present?
        total_count = count.count - 1
        
        unless count.count == 1
          data = count[-2]
          data2 = machine_log.where(programe_number: data[0], parts_count: data[1]).last
          cycle_time = data2.run_time * 60 + data2.run_second.to_i/1000
        else
          data = count[-1]
          cycle_time = 0
        end
      else
      	cycle_time = 0
      	total_count = 0
      end
      utilization = (tot_run*100)/duration
      balance_time = end_time.to_i - Time.now.to_i
      tot_diff = duration - (balance_time + tot_run + tot_idle + tot_stop)
      
      if tot_stop.to_i > tot_run.to_i && tot_stop.to_i > tot_idle.to_i
        total_stop_time = Time.at(tot_stop.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
        total_stop_time = Time.at(tot_stop.to_i).utc.strftime("%H:%M:%S")
      end
      
      if tot_idle.to_i >= tot_run.to_i && tot_idle.to_i >= tot_stop.to_i
         total_idle_time = Time.at(tot_idle.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
         total_idle_time = Time.at(tot_idle.to_i).utc.strftime("%H:%M:%S")
      end
      
      if tot_run.to_i > tot_idle.to_i && tot_run.to_i > tot_stop.to_i
        total_run_time = Time.at(tot_run.to_i + tot_diff.to_i).utc.strftime("%H:%M:%S")
      else
        total_run_time = Time.at(tot_run.to_i).utc.strftime("%H:%M:%S")
      end

      data = {
      	:unit => mac.unit,
      	:machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
        :date =>date,
        :machine_id => mac.id,
        :utilization=>utilization,
        :start_time => machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
        :last_update => machine_log.last.present? ? machine_log.order(:id).last.created_at.in_time_zone("Chennai") : 0,
        :machine_name => mac.machine_name,
        :job_id => job_id,
        :machine_disply => machine_log.last.present? ? machine_log.last.machine_status.to_i : nil,
        :parts_count => total_count,
        :job_wise_part => shift_wise_part,
        :cycle_time => Time.at(cycle_time.to_i).utc.strftime("%H:%M:%S"),
        :run_time => total_run_time,
        :idle_time => total_idle_time,
        :stop_time => total_stop_time,
        :pre_data=> false
	      }
    end
    else
    	data = { message:"No shift Currently Avaliable" }
    end    
  end
end
