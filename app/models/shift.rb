class Shift < ApplicationRecord
	acts_as_paranoid
  has_many :shifttransactions,:dependent => :destroy
  belongs_to :tenant
  has_many :reports
  has_many :hour_reports
  has_many :cnc_hour_reports
  has_many :cnc_reports
  has_many :program_reports
  has_many :ct_reports

  def self.get_all_shift(params)
  	shifts=Tenant.find(params[:tenant_id]).shift.shifttransactions
  	return shifts
  end



def self.check_shift_time22
    @data = []
    date = "2018-08-29"
    tenants = Tenant.where(id: 31)
    tenants.each do |tenant|
      shifts = tenant.shift.shifttransactions
      shifts.each do |shift|
        # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        #   if Time.now.strftime("%p") == "AM"
        #     date = (date.to_date - 1.day).strftime("%Y-%m-%d")
        #   end 
        #   start_time = (date+" "+shift.shift_start_time).to_time
        #   end_time = (date+" "+shift.shift_end_time).to_time+1.day                             
        # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        #   if shift.shift.shift_start_time > Time.now           
        #   if Time.now.strftime("%p") == "AM"
        #     date = (date.to_day - 1.day).strftime("%Y-%m-%d")
        #   end
        #   start_time = (date+" "+shift.shift_start_time).to_time+1.day
        #   end_time = (date+" "+shift.shift_end_time).to_time+1.day
        # else              
        #   start_time = (date+" "+shift.shift_start_time).to_time
        #   end_time = (date+" "+shift.shift_end_time).to_time        
        # end
        
      
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
       else              
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time        
       end
       puts start_time
       puts end_time
     
      #   @data << {
      #          tenant: tenant.tenant_name,
      #          shift: shift.shift_no,
      #          sh_time: shift.shift_start_time+'-'+shift.shift_end_time,
      #          time: start_time.to_time.strftime("%Y-%m-%d || %H:%M:%S")+'------'+end_time.to_time.strftime("%Y-%m-%d || %H:%M:%S")
      #             }
      # #end

    end
    #ShiftCheckingMailer.check_time(@data).deliver_now
  end

end

 def self.check_shift_time
    @data = []
    date = "2018-10-10"
    tenants = Tenant.where(id: [1, 3, 8, 10, 31])
    tenants.each do |tenant|
      shifts = tenant.shift.shifttransactions
      shifts.each do |shift|

        #byebug
        # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        #   if Time.now.strftime("%p") == "AM"
        #     date = (date.to_date - 1.day).strftime("%Y-%m-%d")
        #   end 
        #   start_time = (date+" "+shift.shift_start_time).to_time
        #   end_time = (date+" "+shift.shift_end_time).to_time+1.day                             
        # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        #   if shift.shift.shift_start_time > Time.now           
        #   if Time.now.strftime("%p") == "AM"
        #     date = (date.to_day - 1.day).strftime("%Y-%m-%d")
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
   
        @data << {
               tenant: tenant.tenant_name,
               shift: shift.shift_no,
               sh_time: shift.shift_start_time+'-'+shift.shift_end_time,
               time: start_time.to_time.strftime("%Y-%m-%d || %H:%M:%S")+'------'+end_time.to_time.strftime("%Y-%m-%d || %H:%M:%S")
                  }
      end
    #end
    
  end
  
   ShiftCheckingMailer.check_time(@data).deliver_now
end

   def self.cutting_time(machine_log) 
  cutting_time = [] 
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])

        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            if short_value.count == 1
              data2 = short_value[0]
              data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
              #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
             ### cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
             cutting_time << (machine_log.where(parts_count: data3.parts_count).last.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).last.total_cutting_second.to_i/1000) - (machine_log.where(parts_count: data3.parts_count).first.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).first.total_cutting_second.to_i/1000)
            else
                if index == 0
                  data2 = short_value[0]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at.localtime
                  ##cycle_start_time << machine_log.where(parts_count: short_value[1][1], programe_number: short_value[1][0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                  cutting_time << (machine_log.where(parts_count: data3.parts_count).last.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).last.total_cutting_second.to_i/1000) - (machine_log.where(parts_count: data3.parts_count).first.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).first.total_cutting_second.to_i/1000)
                elsif val == short_value[-1]
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cutting_time << (machine_log.where(parts_count: data3.parts_count).last.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).last.total_cutting_second.to_i/1000) - (machine_log.where(parts_count: data3.parts_count).first.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data3.parts_count).first.total_cutting_second.to_i/1000)
                else
                  data2 = short_value[index+1]
                  ##cycle_start_time << machine_log.where(parts_count: data2[1], programe_number: data2[0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).first.created_at.localtime
                  cutting_time << (machine_log.where(parts_count: data2[1]).last.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data2[1]).last.total_cutting_second.to_i/1000) - (machine_log.where(parts_count: data2[1]).first.total_cutting_time.to_i * 60 + machine_log.where(parts_count: data2[1]).first.total_cutting_second.to_i/1000)
                  #machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0])first.created_at.localtime -
                end
            end
        end
      end
    end

  return cutting_time
end


 def self.stop_to_start_time(machine_log)
  stop_to_start = []
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])

        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            if short_value.count == 1
              data2 = short_value[0]
              data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
              stop_to_start << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).last.created_at.localtime
            else
                if index == 0
                  data2 = short_value[0]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  stop_to_start << machine_log.where(parts_count: short_value[1][1], programe_number: short_value[1][0]).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).last.created_at.localtime
                elsif val == short_value[-1]
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  stop_to_start << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).last.created_at.localtime
                else
                  data2 = short_value[index+1]
                  stop_to_start << machine_log.where(parts_count: data2[1], programe_number: data2[0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last.created_at.localtime
                end
            end
        end
      end
    end
   return stop_to_start
end





end
