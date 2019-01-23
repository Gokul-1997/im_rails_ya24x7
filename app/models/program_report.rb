class ProgramReport < ApplicationRecord
  belongs_to :shift
  belongs_to :operator, -> { with_deleted }, :optional=> true
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant


   
  def self.cnc_hour_report
  #date = Date.today.strftime("%Y-%m-%d")
  date="2018-08-23"
  tenants = Tenant.where(id: [213]).ids
  #tenants = Tenant.where(isactive: true).ids
  @alldata = []
  tenants.each do |tenant|
	tenant = Tenant.find(tenant)
	machines = tenant.machines
	#shifts = tenant.shift.shifttransactions.ids
	#shifts.each do |shift_id|
	 #shift = Shifttransaction.find(5)
	  shift = Shifttransaction.current_shift(tenant.id)
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
		
	  #if start_time < Time.now && end_time > Time.now
		
		loop_count = 1
		(start_time.to_i..end_time.to_i).step(3600) do |hour|
		  (hour.to_i+3600 <= end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))
		  unless hour_start_time[0].to_time == hour_end_time.to_time
		  machines.order(:id).map do |mac|
			machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",hour_start_time[0].to_time,hour_end_time.to_time).order(:id)
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
			program_number = machine_log1.pluck(:programe_number).uniq.reject{|i| i.nil? || i == ""}
			duration = hour_end_time.to_time.to_i - hour_start_time[0].to_time.to_i
			new_parst_count = Machine.new_parst_count(machine_log1)
			
			run_time = Machine.run_time(machine_log1)
			stop_time = Machine.stop_time(machine_log1)
			ideal_time = Machine.ideal_time(machine_log1)
			cycle_time = Machine.cycle_time(machine_log1)
			cycle_time1 = cycle_time.last[:cycle_time]
			tot_down = stop_time + ideal_time
			count = machine_log1.count
			time_diff = duration - (run_time+stop_time+ideal_time)
			
			utilization =(run_time*100)/duration if duration.present?
				
			@alldata << [
			  date,
			  hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
			  Time.at(duration).utc.strftime("%H:%M:%S"),
			  shift.shift.id,
			  shift.shift_no,
			  operator_id,
			  mac.id,
			  program_number,
			  job_description.nil? ? "-" : job_description.split(',').join(" & "),
			  new_parst_count,
			  Time.at(cycle_time1).utc.strftime("%H:%M:%S"),
			  Time.at(stop_time).utc.strftime("%H:%M:%S"),
              Time.at(ideal_time).utc.strftime("%H:%M:%S"),
              Time.at(tot_down).utc.strftime("%H:%M:%S"),
			  Time.at(run_time).utc.strftime("%H:%M:%S"),
			  Time.at(duration).utc.strftime("%H:%M:%S"),
			  utilization,
			  tenant.id,
			  ]
			   
		  end
		#end
	 end    
	end
  end

  @alldata.each do |data|
	if CncHourReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
	CncHourReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], ideal_time: data[10], stop_time: data[11], time_diff: data[12], log_count: data[13], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16])
	else
  #hour_data = CncReport.last_hour_report(data[6],data[15])
  if CncHourReport.where(machine_id:data[6], tenant_id:data[15]).last.present?              
    last_shift_report = CncHourReport.where(machine_id:data[6], tenant_id:data[15]).last
    report_id = CncHourReport.where(machine_id:data[6], tenant_id:data[15]).last
    shift_data = CncHourReport.last_hour_report(last_shift_report.machine_id,last_shift_report.tenant_id)
      unless shift_data.empty?
        report_id.update(date:shift_data[0], time: shift_data[1], hour: shift_data[2], shift_id: shift_data[3], shift_no: shift_data[4], operator_id: shift_data[5], machine_id: shift_data[6], job_description: shift_data[7], parts_produced: shift_data[8], run_time: shift_data[9], ideal_time: shift_data[10], stop_time: shift_data[11], time_diff: shift_data[12], log_count: shift_data[13], utilization: shift_data[14],  tenant_id: shift_data[15], all_cycle_time: shift_data[16])
      end 
  end    

	#HourReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], job_description: data[7], parts_produced: data[8], run_time: data[9], ideal_time: data[10], stop_time: data[11], time_diff: data[12], log_count: data[13], utilization: data[14],  tenant_id: data[15], all_cycle_time: data[16])
	end
  end 
end






end
