class MachineSetting < ApplicationRecord
  belongs_to :machine
  has_many :machine_setting_lists

def self.machine_setting
	Machine.all.each do |mac|
       mac_setting = MachineSetting.create(machine_id: mac.id)
       MachineSettingList.create(machine_setting_id: mac_setting.id, setting_name: "x_axis")
       MachineSettingList.create(machine_setting_id: mac_setting.id, setting_name: "y_axis")
       MachineSettingList.create(machine_setting_id: mac_setting.id, setting_name: "z_axis")
       MachineSettingList.create(machine_setting_id: mac_setting.id, setting_name: "a_axis")
       MachineSettingList.create(machine_setting_id: mac_setting.id, setting_name: "b_axis")
	end
end


  def self.machine_list
  @machine_setting = MachineSetting.create(is_active: true, machine_id: machine_id)
    if @machine_setting.save
    	render json: @machine_setting, status: :created
    else
    	render json: @machine_setting.errors, status: :unprocessable_entity
    end
  end





def self.status
    a = []
    Machine.find(6).machine_setting.machine_setting_lists.each_with_index do |(key, value), index|
     if key.is_active == true && ["x_axis", "y_axis", "z_axis", "a_axis", "b_axis"].include?(key.setting_name)
     a << key
     end
     
    end
end



  def self.new_board123(params)
  tenant = Tenant.find(params[:tenant_id])
  shift = Shifttransaction.current_shift(tenant.id)
  date = Date.today.to_s
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
    duration = end_time.to_i - start_time.to_i
    tenant.machines.order(:id).map do |mac|
    cur_dur = Time.now.to_i - start_time.to_i
   
    machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
    run_time = Machine.calculate_total_run_time(machine_log)
    utilization = (run_time*100)/duration
    #shift_utlz = (cur_dur*100)/duration
   shift_utlz = Time.at(run_time).utc.strftime("%H:%M")
    idle_time = Machine.ideal_time(machine_log)
    #non_utlz = (idle_time*100)/duration
    non_utlz = Time.at(idle_time).utc.strftime("%H:%M")
    
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
            operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last
          else
            operator_id = nil
          end              
          end
        end
        else
        operator_id = nil
        end
      end
      if operator_id.present?
        target = operator_id.target
      else
        target = 0
      end
      data = machine_log.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
      
      if data.count == 1 || data.count == 0
        cycle_time = 0
        parts = 0
      else
     
        cycle_time = machine_log.where(machine_status: 3, parts_count: data[-2][1]).last.run_time.to_i * 60 + machine_log.where(machine_status: 3, parts_count: data[-2][1]).last.run_second.to_i/1000
        parts = data.count
      end
       balance = target - parts
     

     data = {
      :machine_name => mac.machine_name,
      :utilization => utilization,
      :shift_utlz => shift_utlz,
      :non_utlz => non_utlz,
      :machine_id => mac.id,
      :cycle_time => Time.at(cycle_time).utc.strftime("%H:%M:%S"),
      :target => target,
      :parts => parts,
      :machine_status => machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
      :balance => balance

     }
    end

end



    def self.new_board(params)
  tenant = Tenant.find(params[:tenant_id])
  shift = Shifttransaction.current_shift(tenant.id)
  date = Date.today.to_s
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
    duration = end_time.to_i - start_time.to_i
    tenant.machines.order(:id).map do |mac|
    cur_dur = Time.now.to_i - start_time.to_i

    machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
  

  #  run_time = Machine.calculate_total_run_time(machine_log)
    
    if mac.controller_type == 4
      run_time = Machine.run_time(machine_log)
    else
      run_time = Machine.calculate_total_run_time(machine_log)
    end
  


    utilization = (run_time*100)/duration
    #shift_utlz = (cur_dur*100)/duration
   shift_utlz = Time.at(run_time).utc.strftime("%H:%M")
    idle_time = Machine.ideal_time(machine_log)
    #non_utlz = (idle_time*100)/duration
    non_utlz = Time.at(idle_time).utc.strftime("%H:%M")
    
    
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
            operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last
          else
            operator_id = nil
          end
          end
        end
        else
        operator_id = nil
        end
      end
      if operator_id.present?
        target = operator_id.target
      else
        target = 0
      end

      if mac.controller_type == 4
         data = machine_log.where.not(machine_status: 100).split{|o| o.machine_status == 5}.reject{|i| i.empty? }
      else
        data = machine_log.where(machine_status: 3).pluck(:programe_number, :parts_count).uniq
      end

       if data.count == 1 || data.count == 0
        cycle_time = 0
        parts = 0
      else
        
        if mac.controller_type == 4
          cycle_time = data[-2].last.created_at.to_i - data[-2].first.created_at.to_i
        else
        cycle_time = machine_log.where(machine_status: 3, parts_count: data[-2][1]).last.run_time.to_i * 60 + machine_log.where(machine_status: 3, parts_count: data[-2][1]).last.run_second.to_i/1000
        end
        parts = data.count
      end
       balance = target - parts


     data = {
      :machine_name => mac.machine_name,
      :utilization => utilization,
      :shift_utlz => shift_utlz,
      :non_utlz => non_utlz,
      :machine_id => mac.id,
      :cycle_time => Time.at(cycle_time).utc.strftime("%H:%M:%S"),
      :target => target,
      :parts => parts,
      :machine_status => machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
      :balance => balance

     }
    end

end













end
