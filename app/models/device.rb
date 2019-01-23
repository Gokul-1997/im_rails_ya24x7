class Device < ApplicationRecord
	 acts_as_paranoid
	has_many :device_mappings

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
        byebug
      end
  end
end
