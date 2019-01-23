class HourReport < ApplicationRecord
  belongs_to :shift
  belongs_to :operator, -> { with_deleted }, :optional=>true
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant




# def self.hour_reports(params)

#   tenant=Tenant.find(params[:tenant_id])

#   machines=params[:machine_id] == "undefined" ? tenant.machines.ids : Machine.where(id:params[:machine_id]).ids

#   if params[:report_type] == "Shiftwise" && params[:hour_wise] == "true"

#       shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)

#       return HourReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
      
#   elsif params[:report_type] == "Operatorwise" && params[:hour_wise] == "true"

#       return HourReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])	

#   elsif params[:report_type] == "Shiftwise" && params[:program_wise] == "true"

#       shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)

#       return ProgramReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)

#   elsif params[:report_type] == "Operatorwise" && params[:program_wise] == "true"
    
#       return ProgramReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])
#   else
#       puts "no"
#   end

# end




def self.hour_reports(params)
#byebug

#if params[:start_date].to_date > "2018-10-01".to_date

  tenant=Tenant.find(params[:tenant_id])

  machines=params[:machine_id] == "undefined" ? tenant.machines.ids : Machine.where(id:params[:machine_id]).ids

  if params[:report_type] == "Shiftwise" && params[:hour_wise] == "true"
   
      shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)

      return CncHourReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
      
  elsif params[:report_type] == "Operatorwise" && params[:hour_wise] == "true"

      return CncHourReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])  

  elsif params[:report_type] == "Shiftwise" && params[:program_wise] == "true"

      shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
      return ProgramReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)

  elsif params[:report_type] == "Operatorwise" && params[:program_wise] == "true"
    
      return ProgramReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])
  else
      puts "no"
  end
end




def self.hmi_reports(params)
  tenant=Tenant.find(params[:tenant_id])
  machines=params[:machine_id] == "undefined" ? tenant.machines.ids : Machine.where(id:params[:machine_id]).ids
  shifts = params[:shift_id] == "undefined" ? tenant.shift.shifttransactions.pluck(:shift_no) : Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
  return HmiMachineDetail.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
end




def self.cycle_stop_to_start(params) 
  stop_to_start = []
  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncReport.where(date: date, machine_id: machine, shift_no: shift)
  if data.present?
    time = data.first#.pluck(:cycle_time)
    if time.present?
      data.first.stop_to_start.each do |i|
        stop_to_start << i
      end
    end  
  end
 #end
  return stop_to_start
end






def self.all_cycle_time_chat_off_imt(params)
  pg_num_diff = [];
  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncReport.where(date: date, machine_id: machine, shift_no: shift)
  if data.present?
  time = data.first.all_cycle_time#.pluck(:cycle_time)
  if time.present?
    data.first.all_cycle_time.each do |i|
    unless i[:program_number] == "" && i[:program_number] == 0 
      pg_num_diff << i
    end
  end
  start_to_start = []
  if time.present?
    data.first.cycle_start_to_start.each do |i|
    start_to_start << i
  end
end
   end
 end
  return pg_num_diff
end





 def self.all_cycle_time_chat(params)
  pg_num_diff = [];
  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
  data = CncReport.where(date: date, machine_id: machine, shift_no: shift)
  if data.present?
  time = data.first.all_cycle_time#.pluck(:cycle_time)
  if time.present?
    data.first.all_cycle_time.each do |i|
    unless i[:program_number] == "" && i[:program_number] == 0
      i[:shift_no] = data.first.shift_no
      i[:time] = data.first.time
      pg_num_diff << i
    end
  end
  start_to_start = []
  if time.present?
    data.first.cycle_start_to_start.each do |i|
    start_to_start << i
  end
end
   end
 end

  return pg_num_diff
end















def self.cycle_start_to_start(params)
  
  start_to_start = []
  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncReport.where(date: date, machine_id: machine, shift_no: shift)
  if data.present?
    time = data.first#.pluck(:cycle_time)
    if time.present?
      data.first.cycle_start_to_start.each do |i|
        start_to_start << i
      end
    end  
  end
 #end
  return start_to_start
end







def self.hour_parts_count_chart_off_imt(params)
  
  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
  program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  parts = data.pluck(:parts_produced)
  parts = parts.map{|i| i.to_i}
  return {time: time, parts_count: parts, program_number: program_number}
end



  def self.hour_parts_count_chart(params)

  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
 # data5 = CncReport.where(date: date, machine_id: machine, shift_no: shift).first
  program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  parts = data.pluck(:parts_produced)
  parts = parts.map{|i| i.to_i}
  return {time: time, parts_count: parts, program_number: program_number, shift_no: shift.first}
end







def self.hour_machine_status_chart(params)

  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
 # data5 = CncReport.where(date: date, machine_id: machine, shift_no: shift).first
  program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  actual_run = data.pluck(:run_time)

  actual_running = []
  actual_run.each do |time|
    t = time.to_i#Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    actual_running << t
  end

  load_unload = data.pluck(:stop_time)
  stop_time = []
  load_unload.each do |time|
    t = time.to_i#Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    stop_time << t
  end

  idle_time = data.pluck(:ideal_time)
  idle = []
  idle_time.each do |time|
    t = time.to_i#Time.parse(time)
    #Time.at(t).utc.strftime("%H:%M:%S")
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    idle << t
      end
    totttt = []
    totttt << actual_running
    totttt << stop_time
    totttt << idle


  time_diff = data.pluck(:time_diff)
  time_diffo = []
   time_diff.each do |time|
     time_diffo << time.to_i
   end
  # @dd = []
  #time_diff.each_with_index{ |val,index| @dd << totttt.map{|a| a[index]} }

  # time_diff.each_with_index do |val, index|
  #   totttt.map{|i| i[index].to_i.max + time_diff[index].to_i }
  # end
   a = totttt.transpose
   @tot = []
  xx = []
   a.each_with_index do |tim, index|
     #tim
     time_diffo.each do |i|
      vv = tim.all? {|ti| ti == 0}
      if vv == true
        xx << tim
      else
       add_value = i[index]
       ind = tim.each_with_index.max[1]

       # tim.each_with_index do |v, index|
       # if index == ind
       #  xx << v + 10
       # else
       #  xx << v
       # end
       # end
       @tot << xx
      end
       end

   end




  return {time: time, run_time: actual_running, idle_time: idle, stop_time: stop_time, program_number: program_number, no_data: time_diff, shift_no: shift.first}
end










  def self.hour_machine_utliz_chart(params)

  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
#  data5 = CncReport.where(date: date, machine_id: machine, shift_no: shift).first
 program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  actual_run = data.pluck(:run_time)

  actual_running = []
  actual_run.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    actual_running << s2
  end

  load_unload = data.pluck(:stop_time)
  stop_time = []
  load_unload.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    stop_time << s2
  end

  idle_time = data.pluck(:ideal_time)
  idle = []
  idle_time.each do |time|
    s1 = time.to_i

    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    idle << s2
  end
  time_diff = data.pluck(:time_diff)

  no_data = []
  time_diff.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    no_data << s2
  end

  return {time: time, run_time: actual_running, idle_time: idle, stop_time: stop_time, program_number: program_number, no_data: no_data, shift_no: shift.first}
end


def self.hour_machine_status_chart_off_imt(params)

  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
  program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  actual_run = data.pluck(:run_time)
  
  actual_running = []
  actual_run.each do |time|
    t = time.to_i#Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    actual_running << t
  end

  load_unload = data.pluck(:stop_time)
  stop_time = []
  load_unload.each do |time|
    t = time.to_i#Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    stop_time << t
  end

  idle_time = data.pluck(:ideal_time)
  idle = []
  idle_time.each do |time|
    t = time.to_i#Time.parse(time)
    #Time.at(t).utc.strftime("%H:%M:%S")
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    #s2 = s1/60.to_f
    idle << t
  end
    totttt = []
    totttt << actual_running
    totttt << stop_time
    totttt << idle


  time_diff = data.pluck(:time_diff)
  time_diffo = []
   time_diff.each do |time|
     time_diffo << time.to_i
   end
  # @dd = []
  #time_diff.each_with_index{ |val,index| @dd << totttt.map{|a| a[index]} }
  
  # time_diff.each_with_index do |val, index|
  #   totttt.map{|i| i[index].to_i.max + time_diff[index].to_i } 
  # end       
   a = totttt.transpose
   @tot = []
  xx = []
   a.each_with_index do |tim, index|
     #tim
     time_diffo.each do |i|
      vv = tim.all? {|ti| ti == 0}
      if vv == true
        xx << tim
      else
       add_value = i[index]
       ind = tim.each_with_index.max[1]
       
       # tim.each_with_index do |v, index|
       # if index == ind
       #  xx << v + 10
       # else
       #  xx << v
       # end 
       # end
       @tot << xx
      end
     end
   end
  return {time: time, run_time: actual_running, idle_time: idle, stop_time: stop_time, program_number: program_number, no_data: time_diff}
end



def self.hour_machine_utliz_chart_off_imt(params)

  machine = Machine.where(id: params[:machine_id]).ids
  date = params[:date].to_date.strftime("%Y-%m-%d")
  shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)       
  data = CncHourReport.where(date: date, machine_id: machine, shift_no: shift)
  
 program_number = []
  data.pluck(:all_cycle_time).each do |pgnum|
    if pgnum.present?
      program_number << pgnum.pluck(:program_number)
    end
  end

  time = data.pluck(:time)
  actual_run = data.pluck(:run_time)
  
  actual_running = []
  actual_run.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    actual_running << s2
  end

  load_unload = data.pluck(:stop_time)
  stop_time = []
  load_unload.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    stop_time << s2
  end

  idle_time = data.pluck(:ideal_time)
  idle = []
  idle_time.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    idle << s2
  end
  time_diff = data.pluck(:time_diff)

  no_data = []
  time_diff.each do |time|
    s1 = time.to_i
    #t = Time.parse(time)
    #s1 = t.hour * 60 * 60 + t.min * 60 + t.sec
    s2 = s1
    no_data << s2
  end
  
  return {time: time, run_time: actual_running, idle_time: idle, stop_time: stop_time, program_number: program_number, no_data: no_data}
end


  def self.hourly_report1
  
   time_now=Time.now
   date=Date.today.strftime("%Y-%m-%d")
   tenant_active=Tenant.where(id: [3])#.ids
   tenant=Tenant.find(tenant_active)
   @data = []
   machines= tenant.machines.ids#.where(id: 21)       
   shift = Shifttransaction.current_shift(tenant.id)
   #shift = Shifttransaction.find(3)
    #if shift.shift_start_time.to_time + 1.hour  < Time.now
     if shift.shift_no == 1
       shift_no = tenant.shift.shifttransactions.last.shift_no
       date = Date.yesterday.strftime("%Y-%m-%d")
     else
       shift_no = shift.shift_no - 1
     end
       shift_id = shift.shift.id
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
          
        machines.each do |mac|
         if CncReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac).last.present?
           cnc_rep = CncReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac).last
         end
         if cnc_h_rep = CncHourReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac).present?
           cnc_h_rep = CncHourReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac)
         end
         @datass = CncReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: machines)
         @data33 = @datass.pluck(:is_sent)
         
        unless @data33.include?(true)
         if cnc_h_rep.present? && cnc_rep.present?
           if cnc_rep.parts_produced.to_i == cnc_h_rep.pluck(:parts_produced).map(&:to_i).sum
             cnc_h_rep.each do |i|
               @data << i
             end
           else
            puts "not equal"
           end
         else
           puts "not present"
         end
          else
         puts "Newwww Mailererrrrrr"
        end
      end
         
    if @data.present?
     if @data.pluck(:machine_id).uniq.count == machines.count
      require 'csv'
       #path = "#{Rails.root}/public/monthly_project_cost_report_#{Date.today.strftime('%d-%m-%Y')}.csv"
       path = "#{Rails.root}/public/#{tenant.tenant_name}_#{shift_no}_#{Date.today.strftime('%d-%m-%Y')}.csv"
        CSV.open(path, "wb") do |csv|
         csv << ["Date", "Shift", "Time", "Operator Name", "Operator ID", "Machine Name", "Machine ID", "Program Number", "Job Description", "Parts Produced", "CycleTime(M:S)", "Idle Time(Hrs)", "Stop Time(Hrs)", "Actual Running(Hrs)", "Actual Working Hours", "Utilization(%.)"]
           @data.each do |detail|
            if detail.operator_id == nil
             operator_id = "Not Assigned" 
            else
              operator_id = detail.operator.operator_spec_id
            end
              if detail.operator_id == nil
               operator_name = "Not Assigned" 
              else
                operator_name = detail.operator.operator_name
              end

              if detail.all_cycle_time.present?
                cycle = detail.all_cycle_time.pluck(:cycle_time)
                avg_cycl = cycle.inject(0.0) { |sum, el| sum + el } / cycle.size
                cycle_time = Time.at(avg_cycl).utc.strftime("%H:%M:%S")
              else
                cycle_time = "00:00:00"
               end

               if detail.all_cycle_time.present?
                 pg_num = detail.all_cycle_time.pluck(:program_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | ")
               else
                 pg_num = "-"
               end

               if detail.ideal_time.to_i >= detail.run_time.to_i && detail.ideal_time.to_i >= detail.stop_time.to_i
                idle_time = Time.at(detail.ideal_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
               else
                idle_time = Time.at(detail.ideal_time.to_i).utc.strftime("%H:%M:%S")
               end

               if detail.run_time.to_i > detail.ideal_time.to_i && detail.run_time.to_i > detail.stop_time.to_i
                 run_time = Time.at(detail.run_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
              else
                run_time = Time.at(detail.run_time.to_i).utc.strftime("%H:%M:%S")
              end

              if detail.stop_time.to_i > detail.run_time.to_i && detail.stop_time.to_i > detail.ideal_time.to_i
               stop = Time.at(detail.stop_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
             else
               stop = Time.at(detail.stop_time.to_i).utc.strftime("%H:%M:%S")
              end
              act_work = Time.at(detail.hour.to_i).utc.strftime("%H:%M:%S")

             csv << [detail.date, detail.shift_no, detail.time, operator_name, operator_id, detail.machine.machine_name, detail.machine.machine_type, pg_num, detail.job_description, detail.parts_produced, cycle_time, idle_time, stop, run_time, act_work, detail.utilization]
           end
        end
    
        puts "ok"
        
      AlertMailer.hour_report_mailer(path).deliver
       @data2 = CncReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: machines)
       @data2.map{|i| i.update(is_sent: true )}
   
      File.delete(path)
    else
      puts "any one machine Mismatched"

      AlertMailer.wrong_hour_report_mailer(tenant, shift, date).deliver
      #any one machine Mismatched
    end
      #@data2.update_all(is_sent: true)
    end
  #end
end









    def self.hourly_report
     time_now=Time.now
     date=Date.today.strftime("%Y-%m-%d")
     tenant_active=Tenant.where(id: [3])#.ids
     tenant=Tenant.find(tenant_active)
     @data = []
     machines= tenant.machines#.where(id: 21)       
     shift = Shifttransaction.current_shift(tenant.id)
     #shift = Shifttransaction.find(3)
      #if shift.shift_start_time.to_time + 1.hour  < Time.now
       if shift.shift_no == 1
         shift_no = tenant.shift.shifttransactions.last.shift_no
         date = Date.yesterday.strftime("%Y-%m-%d")
       else
         shift_no = shift.shift_no - 1
       end
         shift_id = shift.shift.id
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
            
          machines.each do |mac|   
           if CncHourReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac).present?
             cnc_h_rep = CncHourReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: mac)
           end
            if cnc_h_rep.present?
               cnc_h_rep.each do |i|
                 @data << i
               end
           else
            @data = []
           end
         end
           
      if @data.present?
        require 'csv'
         #path = "#{Rails.root}/public/monthly_project_cost_report_#{Date.today.strftime('%d-%m-%Y')}.csv"
         path = "#{Rails.root}/public/#{tenant.tenant_name}_#{shift_no}_#{Date.today.strftime('%d-%m-%Y')}.csv"
          CSV.open(path, "wb") do |csv|
           csv << ["Date", "Shift", "Time", "Operator Name", "Operator ID", "Machine Name", "Machine ID", "Program Number", "Job Description", "Parts Produced", "CycleTime(M:S)", "Idle Time(Hrs)", "Stop Time(Hrs)", "Actual Running(Hrs)", "Actual Working Hours", "Utilization(%.)"]
             @data.each do |detail|
              if detail.operator_id == nil
               operator_id = "Not Assigned" 
              else
                operator_id = detail.operator.operator_spec_id
              end
                if detail.operator_id == nil
                 operator_name = "Not Assigned" 
                else
                  operator_name = detail.operator.operator_name
                end

                if detail.all_cycle_time.present?
                  cycle = detail.all_cycle_time.pluck(:cycle_time)
                  avg_cycl = cycle.inject(0.0) { |sum, el| sum + el } / cycle.size
                  cycle_time = Time.at(avg_cycl).utc.strftime("%H:%M:%S")
                else
                  cycle_time = "00:00:00"
                 end

                 if detail.all_cycle_time.present?
                   pg_num = detail.all_cycle_time.pluck(:program_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | ")
                 else
                   pg_num = "-"
                 end

                 if detail.ideal_time.to_i >= detail.run_time.to_i && detail.stop_time.to_i
                  idle_time = Time.at(detail.ideal_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
                 else
                  idle_time = Time.at(detail.ideal_time.to_i).utc.strftime("%H:%M:%S")
                 end

                 if detail.run_time.to_i > detail.ideal_time.to_i && detail.stop_time.to_i
                   run_time = Time.at(detail.run_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
                else
                  run_time = Time.at(detail.run_time.to_i).utc.strftime("%H:%M:%S")
                end

                if detail.stop_time.to_i > detail.run_time.to_i && detail.ideal_time.to_i
                 stop = Time.at(detail.stop_time.to_i + detail.time_diff.to_i).utc.strftime("%H:%M:%S")
               else
                 stop = Time.at(detail.stop_time.to_i).utc.strftime("%H:%M:%S")
                end
                act_work = Time.at(detail.hour.to_i).utc.strftime("%H:%M:%S")

               csv << [detail.date, detail.shift_no, detail.time, operator_name, operator_id, detail.machine.machine_name, detail.machine.machine_type, pg_num, detail.job_description, detail.parts_produced, cycle_time, idle_time, stop, run_time, act_work, detail.utilization]
             end
          end
      
          puts "ok"
          
        AlertMailer.hour_report_mailer(path).deliver
        # @data2 = CncReport.where(date: date, shift_id: shift_id, shift_no: shift_no, tenant_id: tenant.id, machine_id: machines)
         #@data2.map{|i| i.update(is_sent: true )}
     
        File.delete(path)
      else
        #puts "any one machine Mismatched"
        #AlertMailer.wrong_hour_report_mailer(tenant, shift, date).deliver
        #any one machine Mismatched
      end
        #@data2.update_all(is_sent: true)
      #end
    #end
  end


  def self.weekly_machine_chart(params)
 tenant=Tenant.find(params[:tenant_id]) 
 if params["days"] == "Today"
  start_date =  Date.today.beginning_of_day.to_date
  end_date = Date.today.end_of_day.to_date
 elsif params["days"] == "Yesterday"
  start_date = (Date.today.beginning_of_day - 1.days).to_date
  end_date = (Date.today.end_of_day - 1.days).to_date
 elsif params["days"] == "This Week"
  start_date = Date.today.beginning_of_week.to_date
  end_date =  Date.today.end_of_day.to_date
 elsif params["days"] == "Last Week"
  start_date = (Date.today.beginning_of_week - 7.days).to_date
  end_date = (Date.today.end_of_week - 7.days).to_date
 elsif params["days"] == "This Month"
  start_date = Date.today.beginning_of_month.to_date
  end_date = Date.today.end_of_day.to_date
 elsif params["days"] == "Last Month"
  start_date =(Date.today - 1.month).beginning_of_month.to_date
  end_date =  (Date.today - 1.month).end_of_month.to_date
 else
  return "No date found"
 end
 if params["machine_id"] == "undefined"
  @val = []  
   @data = tenant.machines.pluck(:id)
    @data.each do |ind|
     @runtime = CncReport.where(date: start_date..end_date, machine_id: ind).pluck(:run_time).map(&:to_i).sum
     @idle = CncReport.where(date: start_date..end_date, machine_id: ind).pluck(:idle_time).map(&:to_i).sum
     @stop = CncReport.where(date: start_date..end_date, machine_id: ind).pluck(:stop_time).map(&:to_i).sum
     @no_data = CncReport.where(date: start_date..end_date, machine_id: ind).pluck(:time_diff).map(&:to_i).sum 
     @machine_name = Machine.find(ind).machine_name 
     @days = (end_date.to_date - start_date.to_date).to_i+1
     @mac = {run_time: @runtime,idle: @idle,stop: @stop,no_data: @no_data, machine_name: @machine_name,start_date: start_date,end_date: end_date,days: @days}
     @val.push(@mac)
    end
  else 
     @runtime = CncReport.where(date: start_date..end_date, machine_id: params["machine_id"]).pluck(:run_time).map(&:to_i).sum
     @idle = CncReport.where(date: start_date..end_date, machine_id: params["machine_id"]).pluck(:idle_time).map(&:to_i).sum
     @stop = CncReport.where(date: start_date..end_date, machine_id: params["machine_id"]).pluck(:stop_time).map(&:to_i).sum
     @no_data = CncReport.where(date: start_date..end_date, machine_id: params["machine_id"]).pluck(:time_diff).map(&:to_i).sum
     @machine_name = Machine.find(params["machine_id"]).machine_name
     @days = (end_date.to_date - start_date.to_date).to_i+1
     @val = [{run_time: @runtime,idle: @idle,stop: @stop,no_data: @no_data, machine_name: @machine_name,start_date: start_date,end_date: end_date,days: @days}]
  end
     return @val
end



def self.shift_machine_utilization_chart(params)
  tenant=Tenant.find(params[:tenant_id])
  program_number = []
  if params["shift_id"] == "undefined"
     shift = tenant.shift.shifttransactions.pluck(:shift_no)
   else
     shift = tenant.shift.shifttransactions.where(id: params[:shift_id]).pluck(:shift_no)
   end
       data = CncReport.where(date: params[:date], machine_id: params[:machine_id], shift_no: shift)
       duration = data.pluck(:hour) 
       shift_number = CncReport.where(date: params[:date], machine_id: params[:machine_id], shift_no: shift).pluck(:shift_no).uniq
       data.pluck(:all_cycle_time).each do |pgnum|
        if pgnum.present?
          program_number << pgnum.pluck(:program_number)
        end
       end
      time = data.pluck(:time)
      actual_running = data.pluck(:run_time).map(&:to_i)
      stop_time = data.pluck(:stop_time).map(&:to_i)
      idle = data.pluck(:idle_time).map(&:to_i)
      no_data = data.pluck(:time_diff).map(&:to_i)
      return {time: time, duration: duration, run_time: actual_running, idle_time: idle, stop_time: stop_time, no_data: no_data,shift_no: shift_number}
  end






def self.shift_machine_status_chart(params)
  tenant=Tenant.find(params[:tenant_id])
  program_number = []
    if params[:shift_id] == "undefined"
      shift = tenant.shift.shifttransactions.pluck(:shift_no)
     else
      shift = tenant.shift.shifttransactions.where(id: params[:shift_id]).pluck(:shift_no)
    end
    data = CncReport.where(date: params["date"], machine_id: params["machine_id"], shift_no: shift)
    shift_number = CncReport.where(date: params[:date], machine_id: params[:machine_id], shift_no: shift).pluck(:shift_no).uniq
     data.pluck(:all_cycle_time).each do |pgnum|
      if pgnum.present?
       program_number << pgnum.pluck(:program_number)
      end
     end
  @data = data.pluck(:time,:run_time,:stop_time,:idle_time,:time_diff)
  time = @data.map {|row| row[0]}
  actual_running = @data.map {|row| row[1]}
  stop_time = @data.map {|row| row[2]}
  idle = @data.map {|row| row[3]}
  time_diff = @data.map {|row| row[4]}
  return {shift: time, run_time: actual_running, stop_time: stop_time, idle_time: idle, no_data: time_diff, shift_no: shift_number}
end






def self.all_cycle_time_chart_new(params)
 pg_num_diff = [];
  tenant=Tenant.find(params[:tenant_id])   
  #shift = Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no)
   if params[:shift_id] == "undefined"
    shift = tenant.shift.shifttransactions.pluck(:shift_no)
  else 
    shift = tenant.shift.shifttransactions.where(id: params[:shift_id]).pluck(:shift_no)
  end

  data2 = CncReport.where(date: params["date"], machine_id: params["machine_id"], shift_no: shift)
  #data2 = CncReport.group_by &:shift_no
  #shift_number = CncReport.where(date: params[:date], machine_id: params[:machine_id], shift_no: shift).pluck(:shift_no).uniq
  if data2.present?
  data2.each do |data|
  time = data.all_cycle_time#.pluck(:cycle_time)
  next if time == []
     #return pg_num_diff.flatten.group_by { |d| d[:shift_no] }
   #else
  @data = time.pluck(:cycle_time).sum/time.count
  if time.present?
    data.all_cycle_time.each do |ind|
    unless ind[:program_number] == "" && ind[:program_number] == 0 
      ind[:shift_no] = data.shift_no
      ind[:time] = data.time
      pg_num_diff << ind.merge(average: @data)
    #end  
    end
  end
 end
 end
 end
  return pg_num_diff.flatten.group_by { |d| d[:shift_no] }
end



















# def self.cnc_hour_report
#   date = Date.today.strftime("%Y-%m-%d")
#   #tenants = Tenant.where(isactive: true).ids
#   tenants = Tenant.where(id: [8, 10]).ids
#   tenants.each do |tenant|
#     tenant = Tenant.find(tenant)
#     machines = tenant.machines
#     shifts = tenant.shift.shifttransactions.ids
#     shifts.each do |shift_id|
#       shift = Shifttransaction.find(shift_id)
#         if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
#           if Time.now.strftime("%p") == "AM"
#             date = (Date.today - 1).strftime("%Y-%m-%d")
#           end 
#           start_time = (date+" "+shift.shift_start_time).to_time
#           end_time = (date+" "+shift.shift_end_time).to_time+1.day                             
#         elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")           
#           if Time.now.strftime("%p") == "AM"
#             date = (Date.today - 1).strftime("%Y-%m-%d")
#           end
#           start_time = (date+" "+shift.shift_start_time).to_time+1.day
#           end_time = (date+" "+shift.shift_end_time).to_time+1.day
#         else              
#           start_time = (date+" "+shift.shift_start_time).to_time
#           end_time = (date+" "+shift.shift_end_time).to_time        
#         end
#       if start_time < Time.now && end_time > Time.now
#         @alldata = []
#         loop_count = 1
#         (start_time.to_i..end_time.to_i).step(3600) do |hour|
#           (hour.to_i+3600 <= end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))
#           machines.order(:id).map do |mac|
#             machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",hour_start_time[0].to_time,hour_end_time.to_time).order(:id)
#             if shift.operator_allocations.where(machine_id:mac.id).last.nil?
#               operator_id = nil
#             else
#               if shift.operator_allocations.where(machine_id:mac.id).present?
#                 shift.operator_allocations.where(machine_id:mac.id).each do |ro| 
#                   aa = ro.from_date
#                   bb = ro.to_date
#                   cc = date
#                   if cc.to_date.between?(aa.to_date,bb.to_date)  
#                     dd = ro#cc.to_date.between?(aa.to_date,bb.to_date)
#                     if dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.present?
#                       operator_id = dd.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id 
#                     else
#                       operator_id = nil
#                     end              
#                   end
#                 end
#               else
#                 operator_id = nil
#               end
#             end
#             duration = hour_end_time.to_time.to_i - hour_start_time[0].to_time.to_i
#             new_parst_count = Machine.new_parst_count(machine_log1)
#             run_time = Machine.run_time(machine_log1)
#             stop_time = Machine.stop_time(machine_log1)
#             ideal_time = Machine.ideal_time(machine_log1)
#             cycle_time = Machine.cycle_time(machine_log1)
#             count = machine_log1.count
#             time_diff = duration - (run_time+stop_time+ideal_time)
#             utilization =(run_time*100)/duration
#             @data = [
#               :date => date,
#               :time => hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
#               :duration => duration,
#               :shift_id => shift_id,
#               :shift_no =>shift.shift_no,
#               :operator_id => operator_id,
#               :machine_id=>mac.id,
#               :job_description=> "-",
#               :parts_produced => new_parst_count,
#               :run_time => run_time,
#               :ideal_time => ideal_time,
#               :stop_time => stop_time,
#               :time_diff => time_diff,
#               :count => count,
#               :utilization => utilization,
#               :tenant_id => tenant_id,
#               :cycle_time => cycle_time
#               ]
#               @alldata << @data
#           end
#         end
#       end    
#     end
#   end
#     @alldata.each do |value|
#       CncHourReport id: nil, date: nil, hour: nil, time: nil, shift_no: nil, job_description: nil, parts_produced: nil, run_time: nil, ideal_time: nil, stop_time: nil, time_diff: nil, log_count: nil, utilization: nil, all_cycle_time: nil, shift_id: nil, operator_id: nil, machine_id: nil, tenant_id: nil, created_at: nil, updated_at: nil>

#     end
# end             



end
