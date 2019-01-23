class OeeCalculation < ApplicationRecord
  belongs_to :machine
  belongs_to :shifttransaction
  has_many :oee_calculate_lists
  serialize :prog_count, Array

  def self.cnc_report_rly(tenant, shift_no, date)
  #date = Date.today.strftime("%Y-%m-%d")
  a = Time.now
  date = date
  @alldata = []
	tenant = Tenant.find(tenant)
	machines = tenant.machines.where(controller_type: 4)
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
		  #machines.where(controller_type: 1, id: 4).order(:id).map do |mac|
      machines.order(:id).map do |mac|
      	machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
       # byebug
        #machine_log1.where.pluck(:machine_status).split(5).reject{|i| i.empty? }.count

       run_time = Machine.run_time(machine_log1)
       stop_time = Machine.stop_time(machine_log1)
       ideal_time = Machine.ideal_time(machine_log1)
       duration = end_time.to_i - start_time.to_i
       count = machine_log1.count
       time_diff = duration - (run_time+stop_time+ideal_time)
       utilization =(run_time*100)/duration if duration.present?
    
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
        short_value = machine_log1.split{|o| o.machine_status == 5}.reject{|i| i.empty? }
        parts_count = short_value.count
        cycle_time = []
        short_value.each_with_index do |val,index|
          #byebug
          cycle_time << val[-1].created_at - val[0].created_at
        end
        cutting_time = cycle_time
        start_cycle_time = cycle_time
        #byebug
         last_cycle_time = []
         
         cycle_time.each do |i|
           last_cycle_time <<   {:program_number=>"10", :cycle_time=>i, :parts_count=>5}
         end


        @alldata << [
        date,
        start_time.strftime("%H:%M:%S")+' - '+end_time.strftime("%H:%M:%S"),
        duration,
        shift.shift.id,
        shift.shift_no,
        operator_id,
        mac.id,
        parts_count,
        run_time,
        ideal_time,
        stop_time,
        time_diff,
        utilization,
        tenant.id,      
        count,
        last_cycle_time,
        start_cycle_time,
        cutting_time
      ] 
      end
#      byebug
      @alldata.each do |data|
        if CncReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[13]).present?
          CncReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[13]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], parts_produced: data[7], run_time: data[8], idle_time: data[9], stop_time: data[10], time_diff: data[11], utilization: data[12], tenant_id: data[13], data_part: data[14], all_cycle_time: data[15], cycle_start_to_start:data[16], cutting_time: data[17])
        else    
          CncReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], parts_produced: data[7], run_time: data[8], idle_time: data[9], stop_time: data[10], time_diff: data[11], utilization: data[12], tenant_id: data[13], data_part: data[14], all_cycle_time: data[15], cycle_start_to_start:data[16], cutting_time: data[17])
        end
    end
  end

   



   

  def self.cnc_hour_report_rely(tenant, shift_no, date)
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

    (start_time.to_i..end_time.to_i).step(3600) do |hour|
      (hour.to_i+3600 <= end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))
      unless hour_start_time[0].to_time == hour_end_time.to_time
      machines.where(controller_type: 4).order(:id).map do |mac|
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
     
      duration = hour_end_time.to_time.to_i - hour_start_time[0].to_time.to_i
      run_time = Machine.run_time(machine_log1)
      stop_time = Machine.stop_time(machine_log1)
      ideal_time = Machine.ideal_time(machine_log1)
      
              
      count = machine_log1.count
      time_diff = duration - (run_time+stop_time+ideal_time)
      utilization =(run_time*100)/duration if duration.present?


       short_value = machine_log1.split{|o| o.machine_status == 5}.reject{|i| i.empty? }
        parts_count = short_value.count
        cycle_time = []
        short_value.each_with_index do |val,index|
          #byebug
          cycle_time << val[-1].created_at - val[0].created_at
        end
        cutting_time = cycle_time
        #byebug
         last_cycle_time = []
         
         cycle_time.each do |i|
           last_cycle_time <<   {:program_number=>"10", :cycle_time=>i, :parts_count=>5}
         end
        
      @alldata << [
        date,
        hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
        duration,
        shift.shift.id,
        shift.shift_no,
        operator_id,
        mac.id,
        #job_description.nil? ? "-" : job_description.split(',').join(" & "),
        parts_count,
        run_time,
        ideal_time,
        stop_time,
        time_diff,
        count,
        utilization,
        tenant.id,
        last_cycle_time,
        cutting_time
        ]  
      end
    #end
   end    
  #end
  end
  @alldata.each do |data|
    if CncHourReport.where(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).present?
      CncHourReport.find_by(date:data[0],shift_no: data[4], time: data[1], machine_id:data[6], tenant_id:data[15]).update(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], parts_produced: data[7], run_time: data[8], ideal_time: data[9], stop_time: data[10], time_diff: data[11], log_count: data[12], utilization: data[13],  tenant_id: data[14], all_cycle_time: data[15],cutting_time: data[16])
    else
      CncHourReport.create!(date:data[0], time: data[1], hour: data[2], shift_id: data[3], shift_no: data[4], operator_id: data[5], machine_id: data[6], parts_produced: data[7], run_time: data[8], ideal_time: data[9], stop_time: data[10], time_diff: data[11], log_count: data[12], utilization: data[13],  tenant_id: data[14], all_cycle_time: data[15],cutting_time: data[16])
    end
  end 
end



















end
 
