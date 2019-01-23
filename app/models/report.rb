class Report < ApplicationRecord
  belongs_to :operator, -> { with_deleted }, :optional=>true
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant
  belongs_to :shift
  serialize :all_cycle_time, Array 



# def self.reports(params)

# tenant=Tenant.find(params[:tenant_id])
# machines=params[:machine_id].present? ? Machine.where(id:params[:machine_id]).ids : tenant.machines.ids
# if params[:report_type] == "Shiftwise"
# 	shifts = params[:shift_id].present? ? Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no) : tenant.shift.shifttransactions.pluck(:shift_no)
# 	return Report.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
# else 
	
#     return Report.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])	
# end
# end



def self.reports(params)

tenant=Tenant.find(params[:tenant_id])
machines=params[:machine_id].present? ? Machine.where(id:params[:machine_id]).ids : tenant.machines.ids
if params[:report_type] == "Shiftwise"
  shifts = params[:shift_id].present? ? Shifttransaction.where(id:params[:shift_id]).pluck(:shift_no) : tenant.shift.shifttransactions.pluck(:shift_no) 
  return CncReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,shift_no: shifts)
else 
  
    return CncReport.where(:tenant_id=>tenant.id,date: params["start_date"]..params["end_date"],machine_id:machines,:operator_id=>params[:operator_id])  
end
end




def self.date_reports1(params)
  
  tenant=Tenant.find(params[:tenant_id])
  machines=params[:machine_id] == "undefined" ? tenant.machines : Machine.where(id:params[:machine_id])
  
  if params[:report_type] == "Datewise Utilization"
  machines.map do | machine_data|

        (params["start_date"].to_date..params["end_date"].to_date).map(&:to_s).map do | date|
           @run_time1=[]
           @shift1=[]
           @time1=[]
           @actual_shifttime1=[]
           @utilization1=[]

            machine_data.reports.where(date:date).map do |data|
              @run_time1 << (Time.parse(data.actual_running).seconds_since_midnight.round() / 60)
              @time1<< data.time
              @shift1 << data.shift_no
              @actual_shifttime1 << (Time.parse(data.actual_working_hours).seconds_since_midnight.round() / 60)
              @utilization1 << data.utilization.to_i

            end
           
           run  = @run_time1.sum
           utilization1 =@utilization1.sum
           shift_time_available  =@actual_shifttime1.sum

           total_shift_time_available = ((shift_time_available/60).round())*60
           utilization =total_shift_time_available == 0 ? 0 : (run*100)/total_shift_time_available # utilization calculation
           utilization = utilization.nil? ? 0 : utilization
         
           data = {
              :date=>date.to_date.strftime("%d-%m-%Y"),
              :shift_no=>@shift1.join(","),
              :time=>@time1.join(","),
              :machine_name=>machine_data.machine_name,
              :machine_type=>machine_data.machine_type,
              :utilization=>utilization
                  }
            end
        end
      elsif params[:report_type] == "Monthwise Utilization"

        machines.map do | machine_data|
         @utilization_month=[]
        (params["start_date"].to_date..params["end_date"].to_date).map(&:to_s).map do | date|
           @run_time1=[]
           @shift1=[]
           @time1=[]
           @actual_shifttime1=[]
           @utilization1=[]

            machine_data.reports.where(date:date).map do |data|
              @run_time1 << (Time.parse(data.actual_running).seconds_since_midnight.round() / 60)
              @time1<< data.time
              @shift1 << data.shift_no
              @actual_shifttime1 << (Time.parse(data.actual_working_hours).seconds_since_midnight.round() / 60)
              @utilization1 << data.utilization.to_i

            end
           
           run  = @run_time1.sum
           utilization1 =@utilization1.sum

           shift_time_available  =@actual_shifttime1.sum

           total_shift_time_available = ((shift_time_available/60).round())*60
           utilization =total_shift_time_available == 0 ? 0 : (run*100)/total_shift_time_available # utilization calculation
           utilization = utilization.nil? ? 0 : utilization
           @utilization_month << utilization
         end
         ut = @utilization_month.sum / @utilization_month.count
       
           data = {
              :date=>params["start_date"].to_date.strftime("%d-%m-%Y")+' - '+params["end_date"].to_date.strftime("%d-%m-%Y"),
              #:shift_no=>@shift1.join(","),
              #:time=>@time1.join(","),
              :machine_name=>machine_data.machine_name,
              :machine_type=>machine_data.machine_type,
              :utilization=>ut
                 }
      end
      else
        puts "no"
      end
end

  def self.date_reports(params)
    tenant=Tenant.find(params[:tenant_id])
    machines=params[:machine_id] == "undefined" ? tenant.machines : Machine.where(id:params[:machine_id])
    @val = [] 
    if params[:report_type] == "Datewise Utilization"
    machines.each do |machine_data|
      (params["start_date"].to_date..params["end_date"].to_date).map(&:to_s).map do | date|
      data = Tenant.find(params["tenant_id"]).machines.find(machine_data)
       detail = CncReport.where(machine_id: machine_data,tenant_id: params["tenant_id"],date: date)
       shift = detail.pluck(:shift_no).uniq
       @data = detail.pluck(:utilization).sum
       utilization = @data == 0 ? @data : @data/shift.count
       machine_name = data.machine_name
       machine_type = data.machine_type
       report_date = date.to_date.strftime("%d-%m-%Y")
       @val.push(shift_no: shift,utilization: utilization,machine_name: machine_name,machine_type: machine_type,date: report_date)
      end
    end
     return @data = (@val)
     elsif params[:report_type] == "Monthwise Utilization"
    machines.each do |machine_data|
      #diff = (params["end_date"].to_date - params["start_date"].to_date).to_i + 1
      data = Tenant.find(params["tenant_id"]).machines.find(machine_data)
      @cal = (params["start_date"].to_date..params["end_date"].to_date).to_a.group_by(&:month).values
      @cal.each do |ind|
      detail = CncReport.where(machine_id: machine_data,tenant_id: params["tenant_id"],date: ind.first..ind.last)
      shift = detail.pluck(:shift_no).uniq
       @data = detail.pluck(:utilization).sum 
       utilization = @data == 0 ? @data : @data / (shift.count * (((ind.last-ind.first).to_i)+1))
       machine_name = data.machine_name 
       machine_type = data.machine_type
       report_date = ind.first.to_date.strftime("%d-%m-%Y")+' - '+ind.last.to_date.strftime("%d-%m-%Y")
       @val.push(shift_no: shift,utilization: utilization,machine_name: machine_name,machine_type: machine_type,date: report_date)
     end
    end
    return @data = (@val)
     else
      puts "no"
    end   
  end

#-------------------------------- Monthwise report for utilization ---------------------------------------------#
=begin
def self.month_reports(params)
  
  tenant=Tenant.find(params[:tenant_id])
  machines=params[:machine_id] == "undefined" ? tenant.machines : Machine.where(id:params[:machine_id])
  machines.map do | machine_data|
    @run_time1=[]
           @shift1=[]
           @time1=[]
           @actual_shifttime1=[]
           @utilization1=[]
        (params["start_date"].to_date..params["end_date"].to_date).map(&:to_s).map do | date|
           

            machine_data.reports.where(date:date).map do |data|
              
              @run_time1 << (Time.parse(data.actual_running).seconds_since_midnight.round() / 60)
              @time1<< data.time
              @shift1 << data.shift_no
              @actual_shifttime1 << (Time.parse(data.actual_working_hours).seconds_since_midnight.round() / 60)
              @utilization1 << data.utilization.to_i

            end
           
           run  = @run_time1.sum
           utilization =@utilization1.sum
           shift_time_available  =@actual_shifttime1.sum

           total_shift_time_available = ((shift_time_available/60).round())*60
           @utilization =total_shift_time_available == 0 ? 0 : (run*100)/total_shift_time_available # utilization calculation
           @utilization2 = @utilization.nil? ? 0 : @utilization
         end
         ut = @utilization1.sum / @utilization1.count
         
           data = {
              :date=>params["start_date"]+' - '+params["end_date"],
              #:shift_no=>@shift1.join(","),
              #:time=>@time1.join(","),
              :machine_name=>machine_data.machine_name,
              :machine_type=>machine_data.machine_type,
              :utilization=>@utilization2
                  }
      end
end
=end


#----------------------------------------------------------------------------------------------------------------#


#-------------------------------  normal shift / operator /date wise Report  -------------------------------------

  def self.test_reports #AAAAA
    time_now=Time.now
    tenant_active=Tenant.where(id: [31]).ids
    #tenant_active=Tenant.where(id:10).ids
    date=Date.today.strftime("%Y-%m-%d")
    @data=[]
    tenant_active.map do |tenant_i| 
      tenant=Tenant.find(tenant_i)
      machines= tenant.machines#.where(id: 21)       
      shiftstarttime=tenant.shift.day_start_time
      #shifts = tenant.shift.shifttransactions #
      #shifts.map do |shift| #
      #shift = Shifttransaction.find(4)
      shift = Shifttransaction.current_shift(tenant.id)
      if shift != []

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
        
        if tenant.id != 213
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

        end_time_for_ideal = time_now < end_time ? time_now : end_time
        total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
        machines.order(:id).map do |mac|
          machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
          total_shift_time_available_for_downtime =  time_now - start_time
			    unless machine_log.present?
      		  downtime = 0
      		else
      		  time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - shift.shift_start_time.to_time.utc.seconds_since_midnight)/60
      		  
            if time_difference >= 10 
      			  total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
            else
      		    total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
            end 
          
           if tenant.id == 8 || tenant.id == 10
             parts_count = Machine.latest_parts_count_calculation_hour(machine_log)  
           else 
             parts_count = Machine.parts_count_calculation(machine_log)#
           end
          
            all_cycle_time = Machine.all_cycle_time_rabwin(machine_log) 

  			    total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
            total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
            parts_count_splitup=[]

            machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
              job_name = "O"+j_name
              if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
     				  else
						    part_count = 0
						  end
              parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
            end
            
            all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
            total_load_unload_time=[]
            targeted_parts=[]
              all_jobs.map do |job|
                job_wise_cycle_time = []
                job_wise_load_unload = []
                job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                job_part.shift
                job_part.pop if job_part.count > 1
                job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                          
                if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                  job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                end
                
                job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
						    job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
						    targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                          
                unless job_wise_load_unload.min.nil?
                  total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                end
              end
            total_load_unload_time = total_load_unload_time.sum
            targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
            cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
            total_shift_time_available = ((total_shift_time_available/60).round())*60
            downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
            job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}  
          end
            total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
            utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
            utilization = utilization.nil? ? 0 : utilization         
            #operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).select{|i| date.to_date.between?(i.from_date,i.to_date)==true}.first.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).select{|i| date.to_date.between?(i.from_date,i.to_date)==true}.first.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil           
            # for operator allocation
            if shift.operator_allocations.where(machine_id:mac.id).last.nil?
              operator_id = nil
            else
              if shift.operator_allocations.where(machine_id:mac.id).present?
                shift.operator_allocations.where(machine_id:mac.id).each do |ro| 
                  if ro.from_date != nil
                    if ro.to_date != nil
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
                    else
                      operator_id = nil
                    end
                  else
                    operator_id = nil
                  end
                end
              else
                operator_id = nil
              end
            end
            total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
            idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
            total_run_time = total_run_time.nil? ? 0 : total_run_time
            targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
            controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
            parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
            parts_last = (controller_part.to_i)
            operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                   
                @data << [
                      date,
	                    shift.shift_no,
	                    shift.shift_start_time+' - '+shift.shift_end_time,
	                    operator_id,
	                    mac.id,
	                    machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
	                    job_description.nil? ? "-" : job_description.split(',').join(" & "),
	                    parts_count,
	                    #parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
	                    parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
	                    Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
	                    Time.at(idle_time).utc.strftime("%H:%M:%S"),
	                    Time.at(downtime).utc.strftime("%H:%M:%S"),
	                    Time.at(total_run_time).utc.strftime("%H:%M:%S"),
	                    shift.actual_working_hours,
	                    #targeted_parts,
	                    #operator_efficiency,
	                    tenant.id,
	                    utilization.nil? || utilization < 0 ? 0 : utilization.round(),
	                    shift.shift_id,
                      all_cycle_time
	                 ]
        end
      end 
      #end 
      @data.map do |data| 

        if Report.where(date:data[0],shift_no: data[1],machine_id:data[4], tenant_id:data[14]).present?
          Report.find_by(date:data[0],shift_no: data[1],machine_id:data[4],tenant_id:data[14]).update(program_number: data[5], operator_id: data[3],job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], utilization:data[15], all_cycle_time: data[17])
        else
          if Report.where(date:data[0],machine_id:data[4], tenant_id:data[14]).last.present?              
            last_shift_report=Report.where(machine_id:data[4], tenant_id:data[14]).last
            report_id=Report.where(machine_id:data[4], tenant_id:data[14]).last.id
            shift_data=Report.last_shift_report(last_shift_report.machine_id,last_shift_report.tenant_id,last_shift_report.shift_id)
            unless shift_data == "no_data"
              last_shift_report.update(program_number: shift_data[5], job_description: shift_data[6],operator_id: data[3], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], utilization: shift_data[15], all_cycle_time: shift_data[16])
              #MachineDailyLog.delete_data #for deleti ng the data
            end
            #MachineDailyLog.where(machine_id:data[4],created_at:)
          end              
          Report.create!(date:data[0], shift_no: data[1], time: data[2], operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], tenant_id: data[14],utilization:data[15],shift_id:data[16], all_cycle_time: data[17])
        end
      end
    end
  end
#---------------------------------------------------------------------------------------------#

#-----------------------------------------------demo normal shift / operator /date wise Report -------------------------#
def self.test_demo_reports
    
        tenant_active=Tenant.where(isactive:true)#yesterday
        date=Date.today.strftime("%Y-%m-%d")
        @data=[]
        tenant_active.map do |tenant_i|
         tenant=Tenant.find(tenant_i)
         machines= tenant.machines 
         shiftstarttime=tenant.shift.day_start_time
         shifts = tenant.shift.shifttransactions
  shifts.map do |shift|
         #shift = Shifttransaction.current_shift(tenant.id)
             
              # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
              #       if Time.now.strftime("%p") == "AM"
              #         date = (Date.today - 1).strftime("%Y-%m-%d")
              #       end 
                    
              #        start_time = (date+" "+shift.shift_start_time).to_time
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day        
              # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
              #   if Time.now.strftime("%p") == "AM"
              #         date = (Date.today - 1).strftime("%Y-%m-%d")
              #       end
              #        start_time = (date+" "+shift.shift_start_time).to_time+1.day
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day
              # else
              #       start_time = (date+" "+shift.shift_start_time).to_time
              #       end_time = (date+" "+shift.shift_end_time).to_time        
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
              total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
            machines.order(:id).map do |mac|
              machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              total_shift_time_available_for_downtime =  Time.now - start_time
          unless machine_log.present?
                   downtime = 0
              else
                   time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - shift.shift_start_time.to_time.utc.seconds_since_midnight)/60
                   if time_difference >= 10 
                    total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
                           else
                    total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
                           end 
                           parts_count = Machine.parts_count_calculation(machine_log)#

                          all_cycle_time = Machine.all_cycle_time(machine_log)


                   total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
                           total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
                           parts_count_splitup=[]
                           machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                                 job_name = "O"+j_name
                                 if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                                    part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                     else
                      part_count = 0
                   end
                                parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
                           end
                           all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                          total_load_unload_time=[]
                          targeted_parts=[]
                          
                          all_jobs.map do |job|
                                  job_wise_cycle_time = []
                                  job_wise_load_unload = []
                                  job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                                  job_part.shift
                                  job_part.pop if job_part.count > 1
                                  job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                                  if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                                    job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                                  end
                                  job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                      job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                                  job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                      targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                                  job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                                  job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                                  unless job_wise_load_unload.min.nil?
                                   total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                                  end
                          end
                          total_load_unload_time = total_load_unload_time.sum
                          targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
                          cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                          total_shift_time_available = ((total_shift_time_available/60).round())*60
                          downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
                          job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                    end
                    total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                    utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                    utilization = utilization.nil? ? 0 : utilization
                    operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
                    total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                    idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                    total_run_time = total_run_time.nil? ? 0 : total_run_time
                    targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                    controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                    parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                    parts_last = (controller_part.to_i)
                    operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                    @data << [ date,
                          shift.shift_no,
                          shift.shift_start_time+' - '+shift.shift_end_time,
                          operator_id,
                          mac.id,
                          machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                          job_description.nil? ? "-" : job_description.split(',').join(" & "),
                          parts_count,
                          #parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                          parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                          Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                          Time.at(idle_time).utc.strftime("%H:%M:%S"),
                          Time.at(downtime).utc.strftime("%H:%M:%S"),
                          Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                          shift.actual_working_hours,
                          #targeted_parts,
                          #operator_efficiency,
                          tenant.id,
                          utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                          shift.shift_id
                       ]
              end
        end
            @data.map do |data|
                 if Report.where(date:data[0],shift_no: data[1],machine_id:data[4], tenant_id:data[14]).present?
                    Report.find_by(date:data[0],shift_no: data[1],machine_id:data[4],tenant_id:data[14]).update(program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], utilization:data[15])
                 else
                  #  if Report.where(date:data[0],machine_id:data[4], tenant_id:data[14]).last.present?
                  #     last_shift_report=Report.where(machine_id:data[4], tenant_id:data[14]).last
                  #     report_id=Report.where(machine_id:data[4], tenant_id:data[14]).last.id
                  #     
                  #     shift_data=Report.last_shift_report(last_shift_report.machine_id,last_shift_report.tenant_id,last_shift_report.shift_id)
                  #     last_shift_report.update(program_number: shift_data[5], job_description: shift_data[6], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], utilization: shift_data[15])
                  #     #MachineDailyLog.delete_data #for deleting the data
                  #     
                  #     #MachineDailyLog.where(machine_id:data[4],created_at:)
                  #  end    

                      Report.create!(date:data[0], shift_no: data[1], time: data[2], operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], tenant_id: data[14],utilization:data[15],shift_id:data[16])
                 end
            end   
            end  
end


def self.last_shift_report(machine_id,tenant_id,shift_id)  #dddd
  machine_id=machine_id
  tenant_id=tenant_id
  report_data=Report.where(machine_id: machine_id,tenant_id: tenant_id,shift_id: shift_id).last
  tenant=Tenant.find(tenant_id)
  time = report_data.time.split("-")
  start_time1 = time[0]
  end_time1 = time[1]
  date=report_data.date.strftime("%Y-%m-%d")
  if Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).present?
    shift=Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).first     
    start_time = (date+" "+start_time1).to_time
    end_time = (date+" "+end_time1).to_time        
    end_time_for_ideal = end_time
    total_shift_time_available = Time.parse(report_data.actual_working_hours).seconds_since_midnight    
    machine_log = report_data.machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    #total_shift_time_available_for_downtime =  Time.now - start_time
    unless machine_log.present?
      downtime = 0
    else
      time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - start_time1.to_time.utc.seconds_since_midnight)/60
      if time_difference >= 10 
        total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
      else
        total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
      end 
      #parts_count = Machine.parts_count_calculation(machine_log)#
     
      if tenant.id == 8 || tenant.id == 10       
       parts_count = Machine.latest_parts_count_calculation_hour(machine_log)  
      else 
        parts_count = Machine.parts_count_calculation(machine_log)#
      end



     all_cycle_time = Machine.all_cycle_time_rabwin(machine_log)


      #total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
      total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
      parts_count_splitup=[]
      machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
        job_name = "O"+j_name
        if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
          part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
        else
          part_count = 0
        end
        parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
      end
      all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
      total_load_unload_time=[]
      targeted_parts=[]
      all_jobs.map do |job|
        job_wise_cycle_time = []
        job_wise_load_unload = []
        job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
        job_part.shift
        job_part.pop if job_part.count > 1
        job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
        if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
          job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
        end
        job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
        job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
        job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
        targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?

        job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
        job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
        unless job_wise_load_unload.min.nil?
          total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
        end
      end
        total_load_unload_time = total_load_unload_time.sum
        targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
        cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
        total_shift_time_available = ((total_shift_time_available/60).round())*60
        downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
        job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
    end

      total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
      utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
      utilization = utilization.nil? ? 0 : utilization
      
      operator_id = shift.operator_allocations.where(machine_id:machine_id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:machine_id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine_id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
      total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
      idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
      total_run_time = total_run_time.nil? ? 0 : total_run_time
      targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
      controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
      parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
      parts_last = (controller_part.to_i)
      operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0

          @data  = [ date,
                    shift.shift_no,
                    shift.shift_start_time+' - '+shift.shift_end_time,
                    operator_id,
                    machine_id,
                    machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                    job_description.nil? ? "-" : job_description.split(',').join(" & "),
                    parts_count,
                    parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                    Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                    Time.at(idle_time).utc.strftime("%H:%M:%S"),
                    Time.at(downtime).utc.strftime("%H:%M:%S"),
                    Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                    shift.actual_working_hours,
                    tenant.id,
                    utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                    all_cycle_time
          ]   
  else 
    return "no_data"    
  end
end
  
#-----------------------------------------------------------hour wise Report ------------------------------------#
  def self.hour_report
        tenant_active=Tenant.where(isactive:true).ids
        #tenant_active=Tenant.where(id: 38).ids
        date=Date.today.strftime("%Y-%m-%d")
        tenant_active.map do |tenant_i|
            tenant=Tenant.find(tenant_i)
            machines= tenant.machines 
            shiftstarttime=tenant.shift.day_start_time
            shift = Shifttransaction.current_shift(tenant.id)
            if shift != []
             
              # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
              #     if Time.now.strftime("%p") == "AM"
              #        date = (Date.today - 1).strftime("%Y-%m-%d")
              #     end 
              #        start_time = (date+" "+shift.shift_start_time).to_time
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day        
              # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
              #     if Time.now.strftime("%p") == "AM"
              #        date = (Date.today - 1).strftime("%Y-%m-%d")
              #     end 
              #        start_time = (date+" "+shift.shift_start_time).to_time+1.day
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day
              # else
              #       start_time = (date+" "+shift.shift_start_time).to_time
              #       end_time = (date+" "+shift.shift_end_time).to_time        
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
              
              loop_count = 1
              (start_time.to_i..end_time.to_i).step(3600) do |hour|

                    (hour.to_i+3600 <= end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))             
                    unless hour_start_time[0] == hour_end_time
                           end_time_for_ideal = Time.now < end_time ? Time.now : end_time
                           total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
                           machines.order(:id).map do |mac|
  
                                machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",hour_start_time[0].to_time,hour_end_time.to_time).order(:id)

                                total_shift_time_available_for_downtime =  Time.now - start_time
                                unless machine_log.present?
                                       downtime = 0
                                else
                                       time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - hour_start_time[0].to_time.utc.seconds_since_midnight)/60
                                       if time_difference >= 10 
                                          total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
                                       else
                                          total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
                                       end 
                                       #parts_count = Machine.parts_count_calculation(machine_log)#
                                       
                                        if tenant.id == 8 || tenant.id == 10
                                          parts_count = Machine.latest_parts_count_calculation_hour(machine_log)  
                                        else 
                                           parts_count = Machine.parts_count_calculation(machine_log)#
                                        end

                                       total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
                                       total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
                                       parts_count_splitup=[]
                                       machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                                            job_name = "O"+j_name
                                            if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                                               part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                                            else
                                               part_count = 0
                                            end
                                            parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
                                       end
                                       all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                                       total_load_unload_time=[]
                                       targeted_parts=[]
                                       all_jobs.map do |job|
                                           job_wise_cycle_time = []
                                           job_wise_load_unload = []
                                           job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                                           job_part.shift
                                           job_part.pop if job_part.count > 1
                                           job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                                           if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                                             job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                                           end
                                          job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                                          job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                                          job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                                          targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                                          job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                                          job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                                          unless job_wise_load_unload.min.nil?
                                            total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                                          end
                                       end
                                       total_load_unload_time = total_load_unload_time.sum
                                       targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
                                       cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                                       total_shift_time_available = ((total_shift_time_available/60).round())*60
                                       downtime =  ((hour_end_time.to_time-hour_start_time[0].to_time)-total_run_time).round()
                                       job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                                end
                                total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                                utilization =(total_run_time*100)/3600 if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                                utilization = utilization.nil? ? 0 : utilization
                                #operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
                  
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
                      
                                total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                                idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                                total_run_time = total_run_time.nil? ? 0 : total_run_time
                                targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                                controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                                parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                                parts_last = (controller_part.to_i)
                                operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                                actual_working_hours = (total_run_time + downtime)
                                
                                data = [ date,
                                         shift.shift_no,
                                         hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
                                         operator_id,
                                         mac.id,
                                         machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                                         job_description.nil? ? "-" : job_description.split(',').join(" & "),
                                         parts_count,
                                         #parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                                         parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                                         Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                                         Time.at(idle_time).utc.strftime("%H:%M:%S"),
                                         Time.at(downtime).utc.strftime("%H:%M:%S"),
                                         Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                                         Time.at(actual_working_hours).utc.strftime("%H:%M:%S"),
                                         #targeted_parts,
                                         #operator_efficiency,
                                         tenant.id,
                                         utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                                         shift.shift_id
                                       ]

                                
                                if HourReport.where(date:data[0], shift_no: data[1], time: data[2],machine_id: data[4], tenant_id: data[14],shift_id:data[16]).present?
                                   HourReport.find_by(date:data[0], shift_no: data[1], time: data[2],machine_id: data[4], tenant_id: data[14],shift_id:data[16]).update(operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13],utilization:data[15])     
                                else
                                  if loop_count == 1
                                     hour_data = Report.last_hour_report(data[4],data[14])
                                     unless hour_data.present?
                                      puts 'no no'
                                     else          
                                     #HourReport.where(date:data[4], shift_no: data[1], time: data[2],machine_id: data[4], tenant_id: data[14],shift_id:data[16]).update(operator_id: hour_data[3], machine_id: hour_data[4], program_number: hour_data[5], job_description: hour_data[6], parts_produced: hour_data[7], cycle_time: hour_data[8], loading_and_unloading_time: hour_data[9], idle_time: hour_data[10], total_downtime: hour_data[11], actual_running: hour_data[12], actual_working_hours: hour_data[13],utilization:hour_data[15])     
                                     HourReport.where(machine_id: data[4], tenant_id: data[14]).order(:id).last.update(operator_id: hour_data[3], machine_id: hour_data[4], program_number: hour_data[5], job_description: hour_data[6], parts_produced: hour_data[7], cycle_time: hour_data[8], loading_and_unloading_time: hour_data[9], idle_time: hour_data[10], total_downtime: hour_data[11], actual_running: hour_data[12], actual_working_hours: hour_data[13],utilization:hour_data[15])     
                                     end
                                  end
                                     HourReport.create!(date:data[0], shift_no: data[1], time: data[2], operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], tenant_id: data[14],utilization:data[15],shift_id:data[16])     
                                end   
                         end
                    end
            loop_count += 1
        end      
      end
    end
end
#-------------------------------------------------------------------------#

def self.last_hour_report(machine_id,tenant_id) 
 machine_id=machine_id
    tenant_id=tenant_id
    hour_dataa=HourReport.where(machine_id: machine_id,tenant_id: tenant_id)
    if hour_dataa.present?
      hour_data=HourReport.where(machine_id: machine_id,tenant_id: tenant_id).last
    tenant=Tenant.find(tenant_id)
    machines = Machine.find(machine_id)
    time= hour_data.time.split("-")
    start_time1 =time[0].gsub(" ","").to_time.strftime("%I:%M %p")
    end_time1 =time[1].gsub(" ","").to_time.strftime("%I:%M %p")
    date=hour_data.date.strftime("%Y-%m-%d")
    
    shift=tenant.shift.shifttransactions.find_by(shift_no: hour_data.shift_no) #time[0].gsub(" ","").to_time.strftime("%I:%M %p"), shift_end_time: time[1].gsub(" ","").to_time.strftime("%I:%M %p")).first
    
      # if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
      #     if Time.now.strftime("%p") == "AM"
      #          date = (Date.today - 1).strftime("%Y-%m-%d")
      #     end
      #     if start_time1.include?("AM")
      #     start_time = (date+" "+start_time1).to_time+1.day
      #     end_time = (date+" "+end_time1).to_time+1.day
      #     else
      #     start_time = (date+" "+start_time1).to_time
      #     end_time = (date+" "+end_time1).to_time+1.day
      #     end

      #     #start_time = (date+" "+start_time1).to_time
      #     #end_time = (date+" "+end_time1).to_time+1.day

      #   elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
      #     if Time.now.strftime("%p") == "AM"
      #          date = (Date.today - 1).strftime("%Y-%m-%d")
      #     end
      #     start_time = (date+" "+start_time1).to_time + 1.day
      #     end_time = (date+" "+end_time1).to_time + 1.day
      #   else
      #     start_time = (date+" "+start_time1).to_time
      #     end_time = (date+" "+end_time1).to_time
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
      

        end_time_for_ideal =end_time
        total_shift_time_available = Time.parse(hour_data.actual_working_hours).seconds_since_midnight
        machine_log = hour_data.machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
        #total_shift_time_available_for_downtime =  Time.now - start_time

        unless machine_log.present?
        downtime = 0
        else
        time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - start_time1.to_time.utc.seconds_since_midnight)/60
            if time_difference >= 10
            total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
            else
            total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
            end
         #parts_count = Machine.parts_count_calculation(machine_log)#
        #total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
         
          if tenant.id == 8 || tenant.id == 10
            
             parts_count = Machine.latest_parts_count_calculation_hour(machine_log)  
           else 
              parts_count = Machine.parts_count_calculation(machine_log)#
           end



        total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model
       


        parts_count_splitup=[]
            machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name|
            job_name = "O"+j_name
                    if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0
                    part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1
                    else
                    part_count = 0
                    end
            parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
            end

        all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
        total_load_unload_time=[]
        targeted_parts=[]

            all_jobs.map do |job|
            job_wise_cycle_time = []
            job_wise_load_unload = []
            job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
            job_part.shift
            job_part.pop if job_part.count > 1
            job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                end

            job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
            job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
            job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
            targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?

            job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
            job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
            unless job_wise_load_unload.min.nil?
              total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
            end

            end

        total_load_unload_time = total_load_unload_time.sum
        targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum

        cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
        total_shift_time_available = ((total_shift_time_available/60).round())*60
        downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
        job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
        end

        total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
        utilization =(total_run_time*100)/3600 if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
        utilization = utilization.nil? ? 0 : utilization

         operator_id = shift.operator_allocations.where(machine_id:machine_id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:machine_id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:machine_id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
        total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
        idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
        total_run_time = total_run_time.nil? ? 0 : total_run_time
        targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
        controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
        parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
        parts_last = (controller_part.to_i)
        operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
        actual_working_hours = (total_run_time + downtime)
        @data  = [  date,
                    shift.shift_no,
                    start_time1+' - '+end_time1,
                    operator_id,
                    machine_id,
                    machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                    job_description.nil? ? "-" : job_description.split(',').join(" & "),
                    parts_count,
                    parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                    Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                    Time.at(idle_time).utc.strftime("%H:%M:%S"),
                    Time.at(downtime).utc.strftime("%H:%M:%S"),
                    Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                    Time.at(actual_working_hours).utc.strftime("%H:%M:%S"),
                    tenant.id,
                    utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                    shift.shift_id
          ]

end
else
  nil
end


#---------------------------------------------------------------------------------------------------#
def self.demo_hour_report

      #hour_start_time=Time.now-1.hour
      #hour_end_time=Time.now
        tenant_active=[39]
        date=Date.today.strftime("%Y-%m-%d")
        #data=[]
        tenant_active.map do |tenant_i|
         tenant=Tenant.find(tenant_i)
         machines= tenant.machines 
         shiftstarttime=tenant.shift.day_start_time
         #shifts = tenant.shift.shifttransactions
         shifts = Shifttransaction.where(id: 33)
shifts.map do |shift|
        #shift = Shifttransaction.current_shift(tenant.id)
               
              #  if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
              #       if Time.now.strftime("%p") == "AM"
              #         date = (Date.today - 1).strftime("%Y-%m-%d")
              #       end 
              #        start_time = (date+" "+shift.shift_start_time).to_time
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day        
              # elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
              #   if Time.now.strftime("%p") == "AM"
              #         date = (Date.today - 1).strftime("%Y-%m-%d")
              #       end 
              #        start_time = (date+" "+shift.shift_start_time).to_time+1.day
              #        end_time = (date+" "+shift.shift_end_time).to_time+1.day
              # else
              #       start_time = (date+" "+shift.shift_start_time).to_time
              #       end_time = (date+" "+shift.shift_end_time).to_time        
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




                (start_time.to_i..end_time.to_i).step(3600) do |hour|
                  (hour.to_i+3600 <= end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))             
                  unless hour_start_time[0] == hour_end_time
                  end_time_for_ideal = Time.now < end_time ? Time.now : end_time
                  total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
                  machines.order(:id).map do |mac|
                      machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",hour_start_time[0].to_time,hour_end_time.to_time).order(:id)
                      total_shift_time_available_for_downtime =  Time.now - start_time
                      unless machine_log.present?
                        downtime = 0
                      else
                        time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - hour_start_time[0].to_time.utc.seconds_since_midnight)/60
                        if time_difference >= 10 
                           total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
                        else
                           total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
                        end 
                        parts_count = Machine.parts_count_calculation(machine_log)#

                        total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
                        total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
                        parts_count_splitup=[]
                        machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                            job_name = "O"+j_name
                            if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                               part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                            else
                               part_count = 0
                            end
                            parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
                        end
                        all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                        total_load_unload_time=[]
                        targeted_parts=[]
                         all_jobs.map do |job|
                             job_wise_cycle_time = []
                             job_wise_load_unload = []
                             job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                             job_part.shift
                             job_part.pop if job_part.count > 1
                             job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                             if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                                job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                             end
                                job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                                job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                                job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                                targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                                job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                                job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                                unless job_wise_load_unload.min.nil?
                                     total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                                end
                         end
                           total_load_unload_time = total_load_unload_time.sum
                           targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
                           cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                           total_shift_time_available = ((total_shift_time_available/60).round())*60
                           downtime =  ((hour_end_time.to_time-hour_start_time[0].to_time)-total_run_time).round()
                           job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                      end
                      total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                      utilization =(total_run_time*100)/3600 if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                      utilization = utilization.nil? ? 0 : utilization
                      operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
                      total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                      idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                      total_run_time = total_run_time.nil? ? 0 : total_run_time
                      targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                      controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                      parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                      parts_last = (controller_part.to_i)
                      operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                      actual_working_hours = (total_run_time + downtime)
                      data = [ date,
                        shift.shift_no,
                        hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
                        operator_id,
                        mac.id,
                        machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                        job_description.nil? ? "-" : job_description.split(',').join(" & "),
                        parts_count,
                        #parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                        parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                        Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                        Time.at(idle_time).utc.strftime("%H:%M:%S"),
                        Time.at(downtime).utc.strftime("%H:%M:%S"),
                        Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                        Time.at(actual_working_hours).utc.strftime("%H:%M:%S"),
                        #targeted_parts,
                        #operator_efficiency,
                        tenant.id,
                        utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                        shift.shift_id
                        ]

                      if HourReport.where(date:data[0], shift_no: data[1], time: data[2],machine_id: data[4], tenant_id: data[14],shift_id:data[16]).present?
                         HourReport.find_by(date:data[0], shift_no: data[1], time: data[2],machine_id: data[4], tenant_id: data[14],shift_id:data[16]).update(operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13],utilization:data[15])     
                      else   
                         HourReport.create!(date:data[0], shift_no: data[1], time: data[2], operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], tenant_id: data[14],utilization:data[15],shift_id:data[16])     
                      end   

                  end
              end
            end
        end      
      end
end
#-------------------------------------program number base Report ---------------------------------#
  def self.program_no_report
   a = Time.now
    tenant_active=Tenant.where(isactive:true).ids
   #tenant_active=Tenant.where(id: 2).ids
        date=Date.today.strftime("%Y-%m-%d")
        #data=[]
        tenant_active.map do |tenant_i|
         tenant=Tenant.find(tenant_i)
         machines= tenant.machines.where(controller_type: 1) 
   #shifts = tenant.shift.shifttransactions
#shifts.map do |shift|
         shiftstarttime=tenant.shift.day_start_time
         shift = Shifttransaction.current_shift(tenant.id)
        # shift = Shifttransaction.find(6)
         if shift != []
              

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
              

     #   if tenant.id != 31 || tenant.id != 10
     #     if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
     #       if Time.now.strftime("%p") == "AM"
     #         date = (Date.today - 1).strftime("%Y-%m-%d")
     #       end 
     #       start_time = (date+" "+shift.shift_start_time).to_time
     #       end_time = (date+" "+shift.shift_end_time).to_time+1.day                       
     #     elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")                
     #       if Time.now.strftime("%p") == "AM"
     #         date = (Date.today - 1).strftime("%Y-%m-%d")
     #       end
     #         start_time = (date+" "+shift.shift_start_time).to_time+1.day
     #         end_time = (date+" "+shift.shift_end_time).to_time+1.day
     #     else
     #       start_time = (date+" "+shift.shift_start_time).to_time
     #       end_time = (date+" "+shift.shift_end_time).to_time        
     #     end
     #   else
     #      case
     #     when shift.day == 1 && shift.end_day == 1   
     #       start_time = (date+" "+shift.shift_start_time).to_time
     #       end_time = (date+" "+shift.shift_end_time).to_time  
     #     when shift.day == 1 && shift.end_day == 2
     #       start_time = (date+" "+shift.shift_start_time).to_time
     #       end_time = (date+" "+shift.shift_end_time).to_time+1.day    
     #     else
     #       start_time = (date+" "+shift.shift_start_time).to_time+1.day
     #       end_time = (date+" "+shift.shift_end_time).to_time+1.day     
     #     end
     #   end


              end_time_for_ideal = Time.now < end_time ? Time.now : end_time
              total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
              total_shift_time_available_for_downtime =  Time.now - start_time
            machines.order(:id).map do |mac|
              machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              
              program_numbers = machine_log1.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}
              
              if program_numbers != []
                
              program_numbers.map do | pn|
                
              machine_log = machine_log1.where(:programe_number=>pn)
               

                unless machine_log.present?
                 downtime = 0
                else
                
                  parts_count = Machine.parts_count_calculation(machine_log)#
                  
                  total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime

                  total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    

                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                   job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                          part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                      else
                        part_count = 0
                      end
                    parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
                   end
                   all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                   total_load_unload_time=[]
                   targeted_parts=[]

                   all_jobs.map do |job|
                    job_wise_cycle_time = []
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                     if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                      job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                     end

                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                    job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                    targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                    
                    job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                      total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                    
                   end

                    total_load_unload_time = total_load_unload_time.sum
                    targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
                   
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60
                  # downtime = (total_shift_time_available - total_run_time).round()
                 #  downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                       downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
                  job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                end
                
                  total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  total_shift_time_available = total_shift_time_available + break_minute if downtime < 0
                  utilization = utilization.nil? ? 0 : utilization
                  #operator_name = shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.present? ? shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_name+"-"+shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.created_at.strftime("%D %I:%M %p") : "Not Assigned"
                  
                 # operator_name = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : nil
                  #operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
                    

                  
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





                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                   
                  #idle_time = downtime - total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                  total_run_time = total_run_time.nil? ? 0 : total_run_time
                  targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0

                  parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                  #parts_count = parts_count.to_i.nil? ? 0 : parts_count

                  operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                  
                   parts_last = (controller_part.to_i)
                   
        data = [
          :date=>date,
          :time=>shift.shift_start_time+' - '+shift.shift_end_time,
          :shift_no =>shift.shift_no, 
          :machine_name=>mac.machine_name,
          :machine_type=>mac.machine_type,
          :machine_id=>mac.id,
          :actual_working_hours=>shift.actual_working_hours,
          :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
          :idle_time=>Time.at(idle_time).utc.strftime("%H:%M:%S"),
          :total_downtime=> Time.at(downtime).utc.strftime("%H:%M:%S"),
          :loading_and_unloading_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
          :parts_produced=>parts_count,
          :operator_id=>operator_id,
          :program_number=>machine_log.last.programe_number,
          :job_description=>job_description.nil? ? "-" : job_description.split(',').join(" & "),
          :tenant_id=>tenant.id,
          :utilization=>utilization.nil? || utilization < 0 ? 0 : utilization.round(),
          :actual_running=>Time.at(total_run_time).utc.strftime("%H:%M:%S"),
          :shift_id=>shift.shift_id
        ]
         

        if ProgramReport.where(date:data[0][:date], shift_no: data[0][:shift_no], time: data[0][:time],machine_id: data[0][:machine_id], tenant_id: data[0][:tenant_id],shift_id:data[0][:shift_id],program_number: data[0][:program_number]).present?
                         ProgramReport.find_by(date:data[0][:date], shift_no: data[0][:shift_no], time: data[0][:time],machine_id: data[0][:machine_id], tenant_id: data[0][:tenant_id],shift_id:data[0][:shift_id],program_number: data[0][:program_number]).update(operator_id: data[0][:operator_id], program_number: data[0][:program_number], job_description: data[0][:job_description], parts_produced: data[0][:parts_produced], cycle_time: data[0][:cycle_time], loading_and_unloading_time: data[0][:loading_and_unloading_time], idle_time: data[0][:idle_time], total_downtime: data[0][:total_downtime], actual_running: data[0][:actual_running], actual_working_hours: data[0][:actual_working_hours],utilization:data[0][:utilization])     
                      else   
                        
                        if ProgramReport.where(date:data[0][:date],machine_id:data[0][:machine_id], tenant_id:data[0][:tenant_id]).last.present?
                      last_program=ProgramReport.where(machine_id:data[0][:machine_id], tenant_id:data[0][:tenant_id]).last
                       #report_id=ProgramReport.where(machine_id:data[0][:machine_id], tenant_id:data[0][:tenant_id]).last.id
                      shift_data=Report.last_program_report(last_program.machine_id,last_program.tenant_id)
                      
                       last_program.update(program_number: shift_data[5], job_description: shift_data[6], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], utilization: shift_data[15])
                       #MachineDailyLog.delete_data #for deleting the data
                       
                       #MachineDailyLog.where(machine_id:data[4],created_at:)
                    end   
                        
                         ProgramReport.create!(date:data[0][:date], shift_no: data[0][:shift_no], time: data[0][:time], operator_id: data[0][:operator_id], machine_id: data[0][:machine_id], program_number: data[0][:program_number], job_description: data[0][:job_description], parts_produced: data[0][:parts_produced], cycle_time: data[0][:cycle_time], loading_and_unloading_time: data[0][:loading_and_unloading_time], idle_time: data[0][:idle_time], total_downtime: data[0][:total_downtime], actual_running: data[0][:actual_running], actual_working_hours: data[0][:actual_working_hours], tenant_id: data[0][:tenant_id],utilization:data[0][:utilization],shift_id: data[0][:shift_id])    
                      end  
               end
            end
          end
      #end
        end
      end
     mac1 = Time.now - a
      CronReport.create(time: mac1.round, report: "2")
  end

def self.last_program_report(machine_id,tenant_id)
  
 machine_id=machine_id
    tenant_id=tenant_id
    report_data=ProgramReport.where(machine_id: machine_id,tenant_id: tenant_id).last
    tenant=Tenant.find(tenant_id)
    mac = Machine.find(machine_id)
     time= report_data.time.split("-")
    start_time1 =time[0]
    end_time1 =time[1]
    date=report_data.date.strftime("%Y-%m-%d")
    if Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).present?
    shift=Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).first
       
    start_time = (date+" "+start_time1).to_time
    end_time = (date+" "+end_time1).to_time        
   
       end_time_for_ideal =end_time
        total_shift_time_available = Time.parse(report_data.actual_working_hours).seconds_since_midnight
        
       # machines.order(:id).map do |mac|
     
              machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              program_numbers = machine_log1.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}
              if program_numbers != []
                
              program_numbers.map do | pn|
              machine_log = machine_log1.where(:programe_number=>pn)
               

                unless machine_log.present?
                 downtime = 0
                else
                
                  parts_count = Machine.parts_count_calculation(machine_log)#
                  #total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime

                  total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    

                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                   job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                          part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                      else
                        part_count = 0
                      end
                    parts_count_splitup << {:job_name=>job_name,:part_count=>part_count}
                   end
                   all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                   total_load_unload_time=[]
                   targeted_parts=[]

                   all_jobs.map do |job|
                    job_wise_cycle_time = []
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                     if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                      job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                     end
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                    job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                    targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                    
                    job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                      total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                   end
                    total_load_unload_time = total_load_unload_time.sum
                    targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
                   
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60
                  # downtime = (total_shift_time_available - total_run_time).round()
                 #  downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                       downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
                  job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                end
                
                  total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  total_shift_time_available = total_shift_time_available + break_minute if downtime < 0
                  utilization = utilization.nil? ? 0 : utilization
                  #operator_name = shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.present? ? shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_name+"-"+shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.created_at.strftime("%D %I:%M %p") : "Not Assigned"
                  
                 # operator_name = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : nil
                  #operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
           
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

                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                   
                  #idle_time = downtime - total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                  total_run_time = total_run_time.nil? ? 0 : total_run_time
                  targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0

                  parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                  #parts_count = parts_count.to_i.nil? ? 0 : parts_count

                  operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                  
                   parts_last = (controller_part.to_i)
                   
      #   data = [
      #     date,
      #     shift.shift_start_time+' - '+shift.shift_end_time,
      #    shift.shift_no, 
      # mac.machine_name,
      #     mac.machine_type,
      #    mac.id,
      #     shift.actual_working_hours,
      #      parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
      #   Time.at(idle_time).utc.strftime("%H:%M:%S"),
      #  Time.at(downtime).utc.strftime("%H:%M:%S"),
      #    Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
      #  parts_count,
      #   operator_id,
      #    machine_log.last.programe_number,
      #     job_description.nil? ? "-" : job_description.split(',').join(" & "),
      #   tenant.id,
      #     utilization.nil? || utilization < 0 ? 0 : utilization.round(),
      #    Time.at(total_run_time).utc.strftime("%H:%M:%S"),
      #   shift.shift_id
      #   ]
       data = [date,
                    shift.shift_no,
                    shift.shift_start_time+' - '+shift.shift_end_time,
                    operator_id,
                    mac.id,
                    machine_log.last.programe_number,
                    job_description.nil? ? "-" : job_description.split(',').join(" & "),
                    parts_count,
                    parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                    Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                    Time.at(idle_time).utc.strftime("%H:%M:%S"),
                    Time.at(downtime).utc.strftime("%H:%M:%S"),
                    Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                    shift.actual_working_hours,
                    tenant.id,
                    utilization.nil? || utilization < 0 ? 0 : utilization.round()
                  ]
#end
end
end
end
end




def self.shift_report #BBB
  time_now=Time.now
  
  date = Date.today.strftime("%Y-%m-%d")
  tenants = Tenant.where(isactive: true)
  @data = []
  tenants.each do |tenant|
    #shift = Shifttransaction.current_shift(tenant.id)
    tenant.shift.shifttransactions.each do |shift|#############
    machines = tenant.machines#Machine.where(id: 5)#
    if shift != []    
      

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


      end_time_for_ideal = time_now < end_time ? time_now : end_time
      total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
      machines.order(:id).map do |mac|
        machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
        unless machine_log.present?
          downtime = 0
        else
          parts_count = Machine.parts_count_calculation(machine_log)#
          total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                        
          
          all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
          total_load_unload_time=[]
          targeted_parts=[]
          all_jobs.map do |job|
            job_wise_cycle_time = []
            job_wise_load_unload = []
            job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
            job_part.shift
            job_part.pop if job_part.count > 1
            job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                      
            if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
              job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
            end
            
            job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
            job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
            job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
            targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
            job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
            job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                      
            unless job_wise_load_unload.min.nil?
              total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
            end
          end
          
            if shift.operator_allocations.where(machine_id:mac.id).last.nil?
              operator_id = nil
            else
              if shift.operator_allocations.where(machine_id:mac.id).present?
                shift.operator_allocations.where(machine_id:mac.id).each do |ro| 
                  if ro.from_date != nil
                    if ro.to_date != nil
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
                    else
                      operator_id = nil
                    end
                  else
                    operator_id = nil
                  end
                end
              else
                operator_id = nil
              end
            end
          downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
          total_load_unload_time = total_load_unload_time.sum
          utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0
          utilization = utilization.nil? ? 0 : utilization 
          total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
          idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
          total_run_time = total_run_time.nil? ? 0 : total_run_time
          controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
          parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
          parts_last = (controller_part.to_i)
          job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
          @data << [
                      date,
                      shift.shift_no,
                      shift.shift_start_time+' - '+shift.shift_end_time,
                      operator_id,
                      mac.id,
                      machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                      job_description.nil? ? "-" : job_description.split(',').join(" & "),
                      parts_count,
                      parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                      Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                      Time.at(idle_time).utc.strftime("%H:%M:%S"),
                      Time.at(downtime).utc.strftime("%H:%M:%S"),
                      Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                      shift.actual_working_hours,
                      tenant.id,
                      utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                      shift.shift_id
          ]
        end
      end
    end
  end
  end##########
  @data.map do |data|
    if Report.where(date:data[0],shift_no: data[1],machine_id:data[4], tenant_id:data[14]).present?
      Report.find_by(date:data[0],shift_no: data[1],machine_id:data[4],tenant_id:data[14]).update(program_number: data[5], operator_id: data[3],job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], utilization:data[15])
    else
      if Report.where(date:data[0],machine_id:data[4], tenant_id:data[14]).present?
        last_shift_report = Report.where(machine_id:data[4], tenant_id:data[14]).last
        shift_data = Report.latest_shift_report(last_shift_report.machine_id,last_shift_report.tenant_id,last_shift_report.shift_id)
        unless shift_data == "no_data"
          if Report.where(date:shift_data[0],shift_no: shift_data[1],machine_id:shift_data[4], tenant_id:shift_data[14]).present?
            Report.find_by(date:shift_data[0],shift_no: shift_data[1],machine_id:shift_data[4],tenant_id:shift_data[14]).update(program_number: shift_data[5], operator_id: shift_data[3],job_description: shift_data[6], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], utilization:shift_data[15])
          else
            Report.create!(date:shift_data[0], shift_no: shift_data[1], time: shift_data[2], operator_id: shift_data[3], machine_id: shift_data[4], program_number: shift_data[5], job_description: shift_data[6], parts_produced: shift_data[7], cycle_time: shift_data[8], loading_and_unloading_time: shift_data[9], idle_time: shift_data[10], total_downtime: shift_data[11], actual_running: shift_data[12], actual_working_hours: shift_data[13], tenant_id: shift_data[14],utilization:shift_data[15],shift_id:shift_data[16])
          end
        end
      end
      Report.create!(date:data[0], shift_no: data[1], time: data[2], operator_id: data[3], machine_id: data[4], program_number: data[5], job_description: data[6], parts_produced: data[7], cycle_time: data[8], loading_and_unloading_time: data[9], idle_time: data[10], total_downtime: data[11], actual_running: data[12], actual_working_hours: data[13], tenant_id: data[14],utilization:data[15],shift_id:data[16])
    end
  end
end


def self.latest_shift_report(machine_id,tenant_id,shift_id) #ccc
  report_data = Report.where(machine_id: machine_id,tenant_id: tenant_id,shift_id: shift_id).last
  tenant = Tenant.find(tenant_id)
  time = report_data.time.split("-")
  start_time1 = time[0]
  end_time1 = time[1]
  date = report_data.date.strftime("%Y-%m-%d")

  # if Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).present?
  #   shift=Shift.find(report_data.shift_id).shifttransactions.where(shift_start_time: time[0].gsub(" ",""), shift_end_time: time[1].gsub(" ","")).first     
  #   start_time = (date+" "+start_time1).to_time
  #   end_time = (date+" "+end_time1).to_time        
  #   end_time_for_ideal =end_time
  #   total_shift_time_available = Time.parse(report_data.actual_working_hours).seconds_since_midnight    
  #   machine_log = report_data.machine.machine_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    
  if Shift.find(report_data.shift_id).shifttransactions.find_by_shift_no(report_data.shift_no).present?
    shift = Shift.find(report_data.shift_id).shifttransactions.find_by_shift_no(report_data.shift_no)
    

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




    end_time_for_ideal = end_time
  machine_log = report_data.machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)

  total_shift_time_available = Time.parse(report_data.actual_working_hours).seconds_since_midnight
    
    if machine_log.present?###############

      parts_count = Machine.parts_count_calculation(machine_log)#
      total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                        
      
      all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
      total_load_unload_time=[]
      targeted_parts=[]
      all_jobs.map do |job|
        job_wise_cycle_time = []
        job_wise_load_unload = []
        job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
        job_part.shift
        job_part.pop if job_part.count > 1
        job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                  
        if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
          job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
        end
        
        job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
        job_wise_cycle_time = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
        job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
        targeted_parts << (machine_log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at) / job_wise_cycle_time.min if machine_log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
        job_wise_load_unload = machine_log.where(programe_number:job).where(parts_count:job_part).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
        job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                  
        unless job_wise_load_unload.min.nil?
          total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
        end
      end
      
        if shift.operator_allocations.where(machine_id:machine_id).last.nil?
          operator_id = nil
        else
          if shift.operator_allocations.where(machine_id:machine_id).present?
            shift.operator_allocations.where(machine_id:machine_id).each do |ro| 
              if ro.from_date != nil
                if ro.to_date != nil
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
                else
                  operator_id = nil
                end
              else
                operator_id = nil
              end
            end
          else
            operator_id = nil
          end
        end
      downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
      total_load_unload_time = total_load_unload_time.sum
      utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0
      utilization = utilization.nil? ? 0 : utilization 
      total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
      idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
      total_run_time = total_run_time.nil? ? 0 : total_run_time
      controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
      parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
      parts_last = (controller_part.to_i)
      job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
      @data = [
                  date,
                  shift.shift_no,
                  shift.shift_start_time+' - '+shift.shift_end_time,
                  operator_id,
                  machine_id,
                  machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
                  job_description.nil? ? "-" : job_description.split(',').join(" & "),
                  parts_count,
                  parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                  Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                  Time.at(idle_time).utc.strftime("%H:%M:%S"),
                  Time.at(downtime).utc.strftime("%H:%M:%S"),
                  Time.at(total_run_time).utc.strftime("%H:%M:%S"),
                  shift.actual_working_hours,
                  tenant.id,
                  utilization.nil? || utilization < 0 ? 0 : utilization.round(),
                  shift.shift_id
      ]
    else
      return "no_data"
    end
  else
    return "no_data"   
  end
end
end
