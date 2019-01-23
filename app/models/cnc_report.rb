class CncReport < ApplicationRecord
  belongs_to :shift
  belongs_to :operator, -> { with_deleted }, :optional=>true
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant
  serialize :all_cycle_time, Array
  serialize :cycle_start_to_start, Array
  serialize :stop_to_start, Array
  serialize :cutting_time, Array  
  serialize :servo_load, Array
  serialize :servo_m_temp, Array
  serialize :puls_code, Array

def self.delay_jobs 
	a = Time.now
  tenants = Tenant.where(id: [10])#isactive: true)
  tenants.each do |tenant|
  	date = Date.today.strftime("%Y-%m-%d")
    shift1 = Shifttransaction.current_shift(tenant.id)
    #shift1 = Shifttransaction.find(2)
  # tenant.shift.shifttransactions.each do |shift1|

   if shift1.shift_start_time.to_time + 25.minutes > Time.now
    if shift1.shift_no == 1
	    shift = tenant.shift.shifttransactions.last
      date = Date.yesterday.strftime("%Y-%m-%d")
    else
      shift = tenant.shift.shifttransactions.where(shift_no: shift1.shift_no - 1).last
    end
     
  #   if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
		#   if Time.now.strftime("%p") == "AM"
		# 	  date = (Date.today - 1).strftime("%Y-%m-%d")
		#   end 
		#   start_time = (date+" "+shift.shift_start_time).to_time
		#   end_time = (date+" "+shift.shift_end_time).to_time+1.day                             
		# elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")

		#   if Time.now.strftime("%p") == "AM" 
		# 	  date = (Date.today - 1).strftime("%Y-%m-%d")
		#   end
		#   if shift.day == 1
  #       start_time = (date+" "+shift.shift_start_time).to_time
  #       end_time = (date+" "+shift.shift_end_time).to_time
  #     else
  #       start_time = (date+" "+shift.shift_start_time).to_time+1.day
  #       end_time = (date+" "+shift.shift_end_time).to_time+1.day
  #     end
		#   #start_time = (date+" "+shift.shift_start_time).to_time+1.day
		#   #end_time = (date+" "+shift.shift_end_time).to_time+1.day
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
		  if shift.day == 1
           start_time = (date+" "+shift.shift_start_time).to_time
           end_time = (date+" "+shift.shift_end_time).to_time
         else
           start_time = (date+" "+shift.shift_start_time).to_time+1.day
           end_time = (date+" "+shift.shift_end_time).to_time+1.day
         end
		 # start_time = (date+" "+shift.shift_start_time).to_time+1.day
		 # end_time = (date+" "+shift.shift_end_time).to_time+1.day
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



    if start_time + 25.minutes > Time.now
	    unless Delayed::Job.where(run_at: shift1.shift_start_time.to_time + 20.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").present?
		    CncReport.delay(run_at: shift1.shift_start_time.to_time + 20.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").cnc_report(tenant.id, shift.shift_no, date)
		  end
	    unless Delayed::Job.where(run_at: shift1.shift_start_time.to_time + 15.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").present?
	    	if tenant.id == 3
	    		HourReport.delay(run_at: shift1.shift_start_time.to_time + 45.minutes, tenant: 3, shift: shift.shift_no, date: date, method: "hour_report").hourly_report
	    	end
	   	  CncHourReport.delay(run_at: shift1.shift_start_time.to_time + 15.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").cnc_hour_report(tenant.id, shift.shift_no, date)
	    end
	  end
	 end 	
  end

end



 
 

  def self.delay_jobs_imtex
  tenants = Tenant.where(isactive: true)
#  tenants = Tenant.where(id: 222)
  tenants.each do |tenant|
   date = Date.today.strftime("%Y-%m-%d")
   tenant.shift.shifttransactions.each do |shift|

           case
          when shift.day == 1 && shift.end_day == 1
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time
          when shift.day == 1 && shift.end_day == 2
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time+1.day
          when shift.day == 2 && shift.end_day == 2
            start_time = (date+" "+shift.shift_start_time).to_time+1.day
            end_time = (date+" "+shift.shift_end_time).to_time+1.day
          end



      unless Delayed::Job.where(run_at: end_time + 4.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").present?
                    CncReport.delay(run_at: end_time + 4.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").cnc_report123(tenant.id, shift.shift_no, date)
                  end
            unless Delayed::Job.where(run_at: end_time + 6.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").present?
                if tenant.id == 136
                        HourReport.delay(run_at: start_time + 20.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "hour_report").hourly_report
                end
                  CncHourReport.delay(run_at: end_time + 6.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").cnc_hour_report1(tenant.id, shift.shift_no, date)
            end

       unless Delayed::Job.where(run_at: end_time + 8.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hmi").present?
                    CncReport.delay(run_at: end_time + 8.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hmi").hmi_reason(tenant.id, shift.shift_no, date)
                  end


    
end
end
end























def self.delay_jobs1
  tenants = Tenant.where(isactive: true)
  tenants.each do |tenant|
    date = Date.today.strftime("%Y-%m-%d")
    tenant.shift.shifttransactions.each do |shift|
       
           case
          when shift.day == 1 && shift.end_day == 1   
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time  
          when shift.day == 1 && shift.end_day == 2
            start_time = (date+" "+shift.shift_start_time).to_time
            end_time = (date+" "+shift.shift_end_time).to_time+1.day    
          when shift.day == 2 && shift.end_day == 2
            start_time = (date+" "+shift.shift_start_time).to_time+1.day
            end_time = (date+" "+shift.shift_end_time).to_time+1.day     
          end
       # end
        # byebug

	    unless Delayed::Job.where(run_at: end_time + 20.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").present?
		    CncReport.delay(run_at: end_time + 20.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_report").cnc_report(tenant.id, shift.shift_no, date)
		  end
	    unless Delayed::Job.where(run_at: end_time + 15.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").present?
	    	if tenant.id == 3
	    		HourReport.delay(run_at: start_time + 45.minutes, tenant: 3, shift: shift.shift_no, date: date, method: "hour_report").hourly_report
	    	end
	   	  CncHourReport.delay(run_at: end_time + 15.minutes, tenant: tenant.id, shift: shift.shift_no, date: date, method: "cnc_hour_report").cnc_hour_report(tenant.id, shift.shift_no, date)
	    end
	  end
  end
end




def self.delay_jobs2

	a = Time.now
  tenants = Tenant.where(id: 8)
  tenants.each do |tenant|
    date = Date.today.strftime("%Y-%m-%d")
    shift = Shifttransaction.current_shift(tenant.id)    
    #shift = Shifttransaction.find(6)
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
      tot_run = Machine.calculate_total_run_time(machine_log)
      tot_stop = Machine.stop_time(machine_log)
	  tot_idle = Machine.ideal_time(machine_log)
	  count = machine_log.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
      
      job_id = machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? ""+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+machine_log.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil
      #machine_log.where(machine_status: 3)
      
      # shift_wise_part = []
      # shift_wise = count.group_by {|(k, v)| k }.map {|k, v1| [k, v1.count]}.to_h
      
      shift_wise_part2 = []
      
       if machine_log.present? && machine_log.where(machine_status: 3).present?
       machine_log.where(machine_status: 3).group_by{|d| d[:programe_number]}.map do |k, v|
       	 cc = v.pluck(:parts_count).uniq.count
         shift_wise_part2 << { program_number: k, parts_count: cc }
       end
       end
      
      # shift_wise_part << shift_wise
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
      status = mac.machine_daily_logs.last.machine_status
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
    #byebug
	    if DashboardDatum.where(date: date, shifttransaction_id: shift.id, machine_id: mac.id).present?
	      data = DashboardDatum.where(date: date, shifttransaction_id: shift.id, machine_id: mac.id).last
	      data.update(utilization: utilization, cycle_time: cycle_time, run_time: total_run_time, idle_time: total_idle_time, stop_time: total_stop_time, job_wise_part: shift_wise_part2, machine_status: total_count, job_id: job_id)
	    else
	      DashboardDatum.create(date: date, utilization:utilization, shift_no:shift.shift_no, shifttransaction_id: shift.id, machine_id: mac.id, tenant_id: tenant.id, cycle_time: cycle_time, run_time: total_run_time, idle_time: total_idle_time, stop_time: total_stop_time, job_wise_part: shift_wise_part2, machine_status: total_count, job_id: job_id)
	    end
     
      end
	end

  	mac1 = Time.now - a
      CronReport.create(time: mac1.round, report: "1")  
end


def self.cnc_report(tenant, shift_no, date)
  #date = Date.today.strftime("%Y-%m-%d")
  a = Time.now
  date = date
  @alldata = []
	tenant = Tenant.find(tenant)
	machines = tenant.machines.where.not(controller_type: 3)
	shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last
		
	# if tenant.id != 31 || tenant.id != 10
	# 	if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
	# 	  if Time.now.strftime("%p") == "AM"
	# 		date = (Date.today - 1).strftime("%Y-%m-%d")
	# 	  end 
	# 	  start_time = (date+" "+shift.shift_start_time).to_time
	# 	  end_time = (date+" "+shift.shift_end_time).to_time+1.day                             
	# 	elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")           
	# 	  if Time.now.strftime("%p") == "AM"
	# 		date = (Date.today - 1).strftime("%Y-%m-%d")
	# 	  end
	# 	  if shift.day == 1
 #           start_time = (date+" "+shift.shift_start_time).to_time
 #           end_time = (date+" "+shift.shift_end_time).to_time
 #         else
 #           start_time = (date+" "+shift.shift_start_time).to_time+1.day
 #           end_time = (date+" "+shift.shift_end_time).to_time+1.day
 #         end
	# 	 # start_time = (date+" "+shift.shift_start_time).to_time+1.day
	# 	 # end_time = (date+" "+shift.shift_end_time).to_time+1.day
	# 	else              
	# 	  start_time = (date+" "+shift.shift_start_time).to_time
	# 	  end_time = (date+" "+shift.shift_end_time).to_time        
	# 	end
	# else
		case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time  
      when shift.day == 1 && shift.end_day == 2
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
	#end

		  machines.where(controller_type: 1).order(:id).map do |mac|
			machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
			if shift.operator_allocations.where(machine_id:mac.id).last.nil?
			  operator_id = nil
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
					else
					  operator_id = nil
					end              
				  end
				end
			  else
				operator_id = nil
			  end
			end

			job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
			duration = end_time.to_i - start_time.to_i
			new_parst_count = Machine.new_parst_count(machine_log1)
			run_time = Machine.run_time(machine_log1)
			stop_time = Machine.stop_time(machine_log1)
			ideal_time = Machine.ideal_time(machine_log1)
						
      if mac.controller_type == 2
        cycle_time = Machine.rs232_cycle_time(machine_log1)	
      else
			  #cycle_time = Machine.cycle_time(machine_log1)
			  cycle_time = Machine.cycle_time22(machine_log1)
      end

			start_cycle_time = Machine.start_cycle_time(machine_log1)
			count = machine_log1.count
			time_diff = duration - (run_time+stop_time+ideal_time)
			utilization =(run_time*100)/duration if duration.present?
			 
			@alldata << [
			  date,
			  start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
			  duration,
			  shift.shift.id,
			  shift.shift_no,
			  operator_id,
			  mac.id,
			  job_description.nil? ? "-" : job_description.split(',').join(" & "),
			  new_parst_count,
			  run_time,
			  ideal_time,
			  stop_time,
			  time_diff,
			  count,
			  utilization,
			  tenant.id,
			  cycle_time,
			  start_cycle_time
			  ] 
		  end
		#end
  #end
  
  if @alldata.present?
    @alldata.each do |data|
      if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
	    CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start: data[17])
	  else    
		CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17])
	  end
    end
  end 
  mac1 = Time.now - a
  CronReport.create(time: mac1.round, report: "1") 
end











def self.cnc_report_speed
	tenants = Tenant.where(id: 8)
  tenants.each do |tenant|
  
  date = Date.today.strftime("%Y-%m-%d")
  @alldata = []
	tenant = Tenant.find(tenant.id)
	machines = tenant.machines.where.not(controller_type: 3)
	#shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last
	shift = Shifttransaction.current_shift(tenant.id)	
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
		  if shift.day == 1
           start_time = (date+" "+shift.shift_start_time).to_time
           end_time = (date+" "+shift.shift_end_time).to_time
         else
           start_time = (date+" "+shift.shift_start_time).to_time+1.day
           end_time = (date+" "+shift.shift_end_time).to_time+1.day
         end
		 # start_time = (date+" "+shift.shift_start_time).to_time+1.day
		 # end_time = (date+" "+shift.shift_end_time).to_time+1.day
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

		  machines.order(:id).map do |mac|
			machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
			if shift.operator_allocations.where(machine_id:mac.id).last.nil?
			  operator_id = nil
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
					else
					  operator_id = nil
					end              
				  end
				end
			  else
				operator_id = nil
			  end
			end

			job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
			duration = end_time.to_i - start_time.to_i
			new_parst_count = Machine.new_parst_count(machine_log1)
			run_time = Machine.run_time(machine_log1)
			stop_time = Machine.stop_time(machine_log1)
			ideal_time = Machine.ideal_time(machine_log1)
						
      if mac.controller_type == 2
        cycle_time = Machine.rs232_cycle_time(machine_log1)	
      else
			  #cycle_time = Machine.cycle_time(machine_log1)
			  cycle_time = Machine.cycle_time22(machine_log1)
      end      
			start_cycle_time = Machine.start_cycle_time(machine_log1)
			count = machine_log1.count
			time_diff = duration - (run_time+stop_time+ideal_time)
			utilization =(run_time*100)/duration if duration.present?
			
			@alldata << [
			  date,
			  start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
			  duration,
			  shift.shift.id,
			  shift.shift_no,
			  operator_id,
			  mac.id,
			  job_description.nil? ? "-" : job_description.split(',').join(" & "),
			  new_parst_count,
			  run_time,
			  ideal_time,
			  stop_time,
			  time_diff,
			  count,
			  utilization,
			  tenant.id,
			  cycle_time,
			  start_cycle_time
			  ] 
		  end
		end
  #end
  
  if @alldata.present?
    @alldata.each do |data|
      if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
	    CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start: data[17])
	  else    
		CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17])
	  end
    end
  end 
end




def self.cnc_report1(tenant, shift_no, date)
  date = date
  @alldata = []
        tenant = Tenant.find(tenant)
        machines = tenant.machines
        shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last

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

                    machines.order(:id).map do |mac|
                machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
                if shift.operator_allocations.where(machine_id:mac.id).last.nil?
                  operator_id = nil
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
                                          else
                                            operator_id = nil
                                          end
                                  end
                                end
                        else
                                operator_id = nil
                        end
                end
                         job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                duration = end_time.to_i - start_time.to_i
                new_parst_count = Machine.new_parst_count1(machine_log1)
              #  new_parst_count = 0
                run_time = Machine.run_time(machine_log1)
                stop_time = Machine.stop_time(machine_log1)
                ideal_time = Machine.ideal_time(machine_log1)
             #  cycle_time = Shift.cycle_time2000(machine_log1)

               if mac.controller_type == 1
                cycle_time = Machine.cycle_time15(machine_log1)
               else
                cycle_time = Machine.rs232_cycle_time15(machine_log1)
               end

               if mac.controller_type == 1
                 start_cycle_time = Machine.start_cycle_time15(machine_log1)
               else
                 start_cycle_time = cycle_time.pluck(:cycle_time)
               end
            #    start_cycle_time = Shift.start_cycle_time1000(machine_log1)
                count = machine_log1.count
                time_diff = duration - (run_time+stop_time+ideal_time)
                utilization =(run_time*100)/duration if duration.present?

                     @alldata << [
                  date,
                  start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
                  duration,
                  shift.shift.id,
                  shift.shift_no,
                  operator_id,
                  mac.id,
                  job_description.nil? ? "-" : job_description.split(',').join(" & "),
                  new_parst_count,
                  run_time,
                  ideal_time,
                  stop_time,
                  time_diff,
                  count,
                  utilization,
                  tenant.id,
                  cycle_time,
                  start_cycle_time
                ]
        end


  if @alldata.present?
    @alldata.each do |data|

     if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
                  CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17])
                else
                        puts "Wrong Data"
                  CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17])
                end


  end
  end
end







  def self.hmi_reason(tenant,shift_no, date)
  date = date
  @alldata = []
  tenant = Tenant.find(tenant)
  machines = tenant.machines.where.not(controller_type: [3,4])
  shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last 
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
    
    machines.order(:id).map do |mac|
    machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    if shift.operator_allocations.where(machine_id:mac.id).last.nil?
      operator_id = nil
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
        else
          operator_id = nil
        end              
        end
      end
      else
      operator_id = nil
      end
    end
    duration = end_time.to_i - start_time.to_i

    tot_run = Machine.run_time(machine_log1)
    tot_stop = Machine.stop_time(machine_log1)
    tot_idle = Machine.ideal_time(machine_log1)

    tot_diff = duration - (tot_run+tot_stop+tot_idle)
    
 
    if tot_idle.to_i >= tot_run.to_i && tot_idle.to_i >= tot_stop.to_i
       total_idle_time = (tot_idle.to_i + tot_diff.to_i)
    else
       total_idle_time = (tot_idle.to_i)
    end
   #byebug

   unless machine_log1.count == 0
      time = []
      final = []
      machine_log1.map do |ll|
        if (ll.machine_status != 3) && (ll.machine_status != 100)
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.cycle_time_per_part]
        else
          unless final.last == "$$"
            final << "$$"
          end
        end
      end
    end
    if final.present?   
      calculate_data = final.split("$$").reject{|i| i.empty? }
    end
    retun_data = []
    if calculate_data.present?
      calculate_data.each do |arra|
        arra.each do |a|
          if arra.count == 1
            if retun_data.present?
              retun_data << a
              retun_data << '##'
            else
              retun_data << a
              retun_data << '##'
            end
          else
            if retun_data.present?
              if arra[-1] == a
                retun_data << a
                retun_data << '##'
              else
                if retun_data[-1][-1] == a[-1]
                  retun_data << a
                else
                  retun_data << '##'
                  retun_data << a
                end
              end
            else
              retun_data << a
            end
          end
        end
      end
    end
    
    calculate_data1 = retun_data.split("##").reject{|i| i.empty? }
   datums = []

   calculate_data1.each do |aa|
    dur = aa.last[0].to_time - aa.first[0].to_time
    res = aa.first[-1]
      datums << [dur, res]
   end
   dd = datums.map{|i| i[0]}.sum
   araindex = datums.each_index.max_by { |i| datums[i][0] }  
  if total_idle_time > dd 
    val1 = total_idle_time - dd
    calculate_data1.each_with_index do |aa, index1|
      if araindex == index1
        dur = (aa.last[0].to_time - aa.first[0].to_time) + val1
        res = aa.first[-1]
        HmiMachineDetail.create(date: date, start_time: aa.first[0].to_time, end_time: aa.last[0].to_time, description: res, shifttransaction_id: shift.id, shift_no: shift.shift_no, duration:dur, machine_id: mac.id, operator_id: operator_id, tenant_id: tenant.id)
      else
        dur = aa.last[0].to_time - aa.first[0].to_time
        res = aa.first[-1]
        HmiMachineDetail.create(date: date, start_time: aa.first[0].to_time, end_time: aa.last[0].to_time, description: res, shifttransaction_id: shift.id, shift_no: shift.shift_no, duration:dur, machine_id: mac.id, operator_id: operator_id, tenant_id: tenant.id)
      end
    end
  elsif total_idle_time == dd 
     calculate_data1.each_with_index do |aa, index1|
      dur = aa.last[0].to_time - aa.first[0].to_time
      res = aa.first[-1]
      HmiMachineDetail.create(date: date, start_time: aa.first[0].to_time, end_time: aa.last[0].to_time, description: res, shifttransaction_id: shift.id, shift_no: shift.shift_no, duration:dur, machine_id: mac.id, operator_id: operator_id, tenant_id: tenant.id)
     end
  else
    val1 = dd - total_idle_time
    if araindex == index1
        dur = (aa.last[0].to_time - aa.first[0].to_time) + val1
        res = aa.first[-1]
        HmiMachineDetail.create(date: date, start_time: aa.first[0].to_time, end_time: aa.last[0].to_time, description: res, shifttransaction_id: shift.id, shift_no: shift.shift_no, duration:dur, machine_id: mac.id, operator_id: operator_id, tenant_id: tenant)
      else
        dur = aa.last[0].to_time - aa.first[0].to_time
        res = aa.first[-1]
        HmiMachineDetail.create(date: date, start_time: aa.first[0].to_time, end_time: aa.last[0].to_time, description: res, shifttransaction_id: shift.id, shift_no: shift.shift_no, duration:dur, machine_id: mac.id, operator_id: operator_id, tenant_id: tenant)
      end
  end
    #byebug
  end
end



   #----------------All Data Report------------------#
 
  def self.cnc_report1234(tenant, shift_no, date)
  #date = Date.today.strftime("%Y-%m-%d")
    a = Time.now
    date = date
    @alldata = []
    tenant = Tenant.find(tenant)
    machines = tenant.machines.where.not(controller_type: 3)
    shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last	

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
	#end
       machines.where(controller_type: 1).order(:id).map do |mac|
	machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
	if shift.operator_allocations.where(machine_id:mac.id).last.nil?
	  operator_id = nil
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
		  target = dd.operator_mapping_allocations.where(:date=>date.to_date).last.target
                else
		  operator_id = nil
                  target = 0
		end
             else
              operator_id = nil
               target = 0            
	      end
           end
          else
	    operator_id = nil
            target = 0
	   end
         end
			job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
			duration = end_time.to_i - start_time.to_i
			new_parst_count = Machine.new_parst_count1(machine_log1)
			run_time = Machine.run_time(machine_log1)
			stop_time = Machine.stop_time(machine_log1)
			ideal_time = Machine.ideal_time(machine_log1)
                        stop_to_start = Shift.stop_to_start_time(machine_log1)
                        cutting_time = Shift.cutting_time(machine_log1)
						
	

               if mac.controller_type == 1
                cycle_time = Machine.cycle_time15(machine_log1)
               else
                cycle_time = Machine.rs232_cycle_time15(machine_log1)
               end

               if mac.controller_type == 1
                 start_cycle_time = Machine.start_cycle_time15(machine_log1)
               else
                 start_cycle_time = cycle_time.pluck(:cycle_time)
               end








            	     #   start_cycle_time = Machine.start_cycle_time(machine_log1)
			count = machine_log1.count
			time_diff = duration - (run_time+stop_time+ideal_time)
			utilization =(run_time*100)/duration if duration.present?
       

       data4 = ShiftPart.where(date: date, machine_id:mac.id, shift_no: shift.shift_no)
       data_parts_count = data4.count
       approved = data4.where(status: 1).count
       rework = data4.where(status: 2).count
       rejected = data4.where(status: 3).count
       
       if target == 0
         pending = 0
       else
         pending = target - data_parts_count
       end

       feed_rate_min = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.min
       feed_rate_max = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.max
       
       spindle_speed_min = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.min
       spindle_speed_max = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.max
			
			@alldata << [
			  date,
			  start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
			  duration,
			  shift.shift.id,
			  shift.shift_no,
			  operator_id,
			  mac.id,
			  job_description.nil? ? "-" : job_description.split(',').join(" & "),
			  new_parst_count,
			  run_time,
			  ideal_time,
			  stop_time,
			  time_diff,
			  count,
			  utilization,
			  tenant.id,
			  cycle_time,
			  start_cycle_time,
                          feed_rate_min.to_s+' - '+feed_rate_max.to_s,
                          spindle_speed_min.to_s+' - '+spindle_speed_max.to_s,
                          data_parts_count,
                          target,
                          pending,
                          approved,
                          rework,
                          rejected,
                          stop_to_start,
                          cutting_time
			  ] 
		  end
		#end
  #end
  
  if @alldata.present?
    @alldata.each do |data|
      if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
	      CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start: data[17], feed_rate: data[18], spendle_speed: data[19], data_part: data[20], target:data[21], approved: data[23], rework: data[24], reject: data[25], stop_to_start: data[26], cutting_time: data[27])
	    else    
		    CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17], feed_rate: data[18], spendle_speed: data[19], data_part: data[20], target:data[21], approved: data[23], rework: data[24], reject: data[25], stop_to_start: data[26], cutting_time: data[27])
	    end
    end
  end 
  mac1 = Time.now - a
  CronReport.create(time: mac1.round, report: "1") 
end


   #-----------------END-----------------------------#
   #-----------------final---------------------------#

    def self.cnc_report123(tenant, shift_no, date)
  #date = Date.today.strftime("%Y-%m-%d")
    a = Time.now
    date = date
    @alldata = []
    tenant = Tenant.find(tenant)
    machines = tenant.machines.where.not(controller_type: 3)
    shift = tenant.shift.shifttransactions.where(shift_no: shift_no).last

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
        
       machines.where(controller_type: 1).order(:id).map do |mac|
        machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
   #     byebug
        if shift.operator_allocations.where(machine_id:mac.id).last.nil?
          operator_id = nil
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
                  target = dd.operator_mapping_allocations.where(:date=>date.to_date).last.target
                else
                  operator_id = nil
                  target = 0
                end
             else
              operator_id = nil
               target = 0
              end
           end
          else
            operator_id = nil
            target = 0
           end
         end
                        job_description = machine_log1.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                        duration = end_time.to_i - start_time.to_i
                        new_parst_count = Machine.new_parst_count1(machine_log1)
                        run_time = Machine.run_time(machine_log1)
                        stop_time = Machine.stop_time(machine_log1)
                        ideal_time = Machine.ideal_time(machine_log1)
                        stop_to_start = Shift.stop_to_start_time(machine_log1)
                        cutting_time = Shift.cutting_time(machine_log1)


                      if mac.controller_type == 1
                cycle_time = Machine.cycle_time15(machine_log1)
               else
                cycle_time = Machine.rs232_cycle_time15(machine_log1)
               end

               if mac.controller_type == 1
                 start_cycle_time = Machine.start_cycle_time15(machine_log1)
               else
                 start_cycle_time = cycle_time.pluck(:cycle_time)
               end








                     #   start_cycle_time = Machine.start_cycle_time(machine_log1)
                        count = machine_log1.count
                        time_diff = duration - (run_time+stop_time+ideal_time)
                        utilization =(run_time*100)/duration if duration.present?


       data4 = ShiftPart.where(date: date, machine_id:mac.id, shift_no: shift.shift_no)
       data_parts_count = data4.count
       approved = data4.where(status: 1).count
       rework = data4.where(status: 2).count
       rejected = data4.where(status: 3).count

       if target == 0
         pending = 0
       else
         pending = target - data_parts_count
       end
      
     
  #     feed_rate_min = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.map(&:to_i).min
       feed_rate_max = machine_log1.pluck(:feed_rate).reject{|i| i == "" || i.nil? || i > 5000 || i == 0 }.map(&:to_i).max
       
   #    spindle_speed_min = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min
       spindle_speed_max = machine_log1.pluck(:cutting_speed).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max
      
      sp_temp_min = machine_log1.pluck(:z_axis).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min
      sp_temp_max = machine_log1.pluck(:z_axis).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max

      spindle_load_min = machine_log1.pluck(:spindle_load).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min
      spindle_load_max = machine_log1.pluck(:spindle_load).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max

      mac_setting_id =  MachineSetting.find_by(machine_id: mac.id).id			
      data_val = MachineSettingList.where(machine_setting_id: mac_setting_id, is_active: true).pluck(:setting_name)
       
       axis_loadd = []
       tempp_val = []
       puls_coder = []
      

      if machine_log1.present?
      machine_log1.last.x_axis.first.each_with_index do |key, index|
        if data_val.include?(key[0].to_s)
       # key = 0
          load_value =  machine_log1.pluck(:x_axis).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min.to_s+' - '+machine_log1.pluck(:x_axis).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max.to_s
          temp_value =  machine_log1.pluck(:y_axis).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min.to_s+' - '+machine_log1.pluck(:y_axis).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max.to_s
          puls_value =  machine_log1.pluck(:cycle_time_minutes).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).min.to_s+' - '+machine_log1.pluck(:cycle_time_minutes).sum.pluck(key[0]).reject{|i| i == "" || i.nil? || i == 0 }.map(&:to_i).max.to_s
          
          if load_value == " - "
            load_value = "0 - 0" 
          end

          if temp_value == " - "
            temp_value = "0 - 0" 
          end

          if puls_value == " - "
            puls_value = "0 - 0" 
          end
          
          axis_loadd << {key[0].to_s.split(":").first => load_value}
          tempp_val << {key[0].to_s.split(":").first => temp_value}
          puls_coder << {key[0].to_s.split(":").first => puls_value}
        else
          axis_loadd << {key[0].to_s.split(":").first => "0 - 0"}
          tempp_val <<  {key[0].to_s.split(":").first => "0 - 0"}
          puls_coder << {key[0].to_s.split(":").first => "0 - 0"}
        end
      end
      end


        oee_perfomance = []
      oee_qty = []

     if OeeCalculation.where(date: date, machine_id: mac.id, shifttransaction_id: shift.id).present?
       oee_part = OeeCalculation.where(date: date, machine_id: mac.id, shifttransaction_id: shift.id).last.oee_calculate_lists       
       oee_part.each do |pgn|  
         oee_perfomance << (pgn.run_rate.to_i * pgn.parts_count.to_i)/(pgn.time.to_i).to_f
         shift_part_count = ShiftPart.where(date: date, machine_id: mac.id, shifttransaction_id: shift.id, program_number: pgn.program_number) 
         if shift_part_count.count == 0
           oee_qty << 0
         else
           good_pieces = shift_part_count.where(status: 1).count
           oee_qty << (good_pieces)/(pgn.parts_count.to_i).to_f
         end
       end
      else
        oee_perfomance = [0]
        oee_qty = [0]
      end
       
        avialabilty = 1
        perfomance = oee_perfomance.inject{ |sum, el| sum + el }.to_f / oee_perfomance.size
        quality = oee_qty.inject{ |sum, el| sum + el }.to_f / oee_qty.size


                        @alldata << [
                          date,
                          start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
                          duration,
                          shift.shift.id,
                          shift.shift_no,
                          operator_id,
                          mac.id,
                          job_description.nil? ? "-" : job_description.split(',').join(" & "),
                          new_parst_count,
                          run_time,
                          ideal_time,
                          stop_time,
                          time_diff,
                          count,
                          utilization,
                          tenant.id,
                          cycle_time,
                          start_cycle_time,
                          feed_rate_max.to_s,
                          spindle_speed_max.to_s,
                          data_parts_count,
                          target,
                          pending,
                          approved,
                          rework,
                          rejected,
                          stop_to_start,
                          cutting_time,
                          spindle_load_min.to_s+' - '+spindle_load_max.to_s,
                          sp_temp_min.to_s+' - '+sp_temp_max.to_s,
                          axis_loadd,
                          tempp_val,
                          puls_coder,
                          avialabilty,
                          perfomance,
                          quality
                          ]
                  end
                #end
  #end

      if @alldata.present?
    @alldata.each do |data|
      if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
              CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start: data[17], feed_rate: data[18], spendle_speed: data[19], data_part: data[20], target:data[21], approved: data[23], rework: data[24], reject: data[25], stop_to_start: data[26], cutting_time: data[27],spindle_load: data[28], spindle_m_temp: data[29], servo_load: data[30], servo_m_temp: data[31], puls_code: data[32],availability: data[33], perfomance: data[34], quality: data[35])
            else
                    CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], idle_time: data[10], stop_time: data[11], time_diff: data[12], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16], cycle_start_to_start:data[17], feed_rate: data[18], spendle_speed: data[19], data_part: data[20], target:data[21], approved: data[23], rework: data[24], reject: data[25], stop_to_start: data[26], cutting_time: data[27],spindle_load: data[28], spindle_m_temp: data[29], servo_load: data[30], servo_m_temp: data[31], puls_code: data[32],availability: data[33], perfomance: data[34], quality: data[35])
            end
    end
  end
  mac1 = Time.now - a
  CronReport.create(time: mac1.round, report: "1")
end






   #-----------------End-----------------------------#


end


