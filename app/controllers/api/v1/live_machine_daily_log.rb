def self.dashboard_status(params)
   tenant=Tenant.find(params[:tenant_id])
    shift = Shifttransaction.current_shift(tenant.id)
     date = Date.today.to_s

   if params[:type] == "Alarm"
    tenant.machines.order(:id).map do |mac|
               data ={
                unit:mac.unit,
                date:date,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
                :alarm=>mac.alarms.last,
                :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
                :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
                :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
                :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
               }
            end
         else
    if shift != []
    date = Date.today.to_s
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        if Time.now.strftime("%p") == "AM"
          date = Date.today - 1
        end
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date +" "+shift.shift_end_time).to_time + 1.day
    else
       start_time = (date+" "+shift.shift_start_time).to_time
       end_time = (date+" "+shift.shift_end_time).to_time
    end
          total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
          actual_working_time = Time.now - shift.shift_start_time.to_time
             tenant.machines.order(:id).map do |mac|
                machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
                total_shift_time_available_for_downtime =  Time.now - start_time
                tot_run_time = Machine.calculate_total_run_time(machine_log)
                utilization =(tot_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  utilization = utilization.nil? ? 0 : utilization
                   data = {

               :unit=>mac.unit,
                :date=>date,
                :shift_no=>shift.shift_no,
                :last_update=>mac.machine_logs.last.present? ? mac.machine_logs.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
               # :machine_status_test=>machine_log.last.present? ? machine_log.last.machine_status : nil,
                :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                :utilization=>utilization.round(),
                :start_time=>start_time,
                :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0

               }

             end
         else
         data = { message:"No shift Currently Avaliable" }
      end
      end
  end
#----------------------------------------------------

def self.machine_process(params)
    tenant=Tenant.find(params[:tenant_id])
    mac=Machine.find(params[:machine_id])
    shift = Shifttransaction.current_shift(tenant.id)
    if shift != []
    date = Date.today.to_s
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        if Time.now.strftime("%p") == "AM"
          date = Date.today - 1
        end
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date +" "+shift.shift_end_time).to_time + 1.day
    else
       start_time = (date+" "+shift.shift_start_time).to_time
       end_time = (date+" "+shift.shift_end_time).to_time
    end
          total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
          actual_working_time = Time.now - shift.shift_start_time.to_time

             #machines.map do |mac|

                machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
                total_shift_time_available_for_downtime =  Time.now - start_time

                unless machine_log.present?
                 downtime = 0
                else

                   parts_count = Machine.parts_count_calculation(machine_log)
                   total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime

                   total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model

                   if mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).present?
                    entry_data_run_time = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:run_time).sum
                    total_run_time = total_run_time + entry_data_run_time
                    entry_parts = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:parts_produced).sum
                    parts_count = parts_count + entry_parts.to_i
                   end
                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name|
                    if machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.count > 1
                      job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0
                       part_split_job = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).split("0")
                          part_count_job=[]
                        part_split_job.uniq.map do |part|
                    unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split_job[0].empty?
                              part_count_job << part[-1].to_i
                           else
                             part_count_job << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count_job << part[-1].to_i
                        end
                      elsif part_split_job.index(part) != 0 && part[0] != machine_log.first.parts_count
                          part_count_job << part[0].to_i
                      end
                     end
                    end
                      else
                        part_count_job = 0
                      end
                    else
                     part_count_job = [parts_count]
                    end
                     part_count_job = part_count_job.select(&0.method(:<)).sum < 0 ? 0 : part_count_job.select(&0.method(:<)).sum
                    parts_count_splitup << {:job_name=>"O"+j_name,:part_count=>part_count_job}
                   end
                    all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                    total_load_unload_time=[]
                    all_jobs.map do |job|
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                    job_part_load_unload.shift if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1
                    job_wise_load_unload = machine_log.where(parts_count:job_part).where(programe_number:job).group_by(&:parts_count).map{|pp,qq| qq.last.run_time.nil? ? 0 : (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                        total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                   end
                    total_load_unload_time = total_load_unload_time.sum
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60

                   downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                  end

                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  utilization = utilization.nil? ? 0 : utilization
                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                 # @stop_time=[]
                 # machine_log.where(machine_status:"100").map do |stop|
                 # @stop_time << stop.created_at
                 # end
                 # total_stop_time=(@stop_time.count)*1
#-----------------------------------stop time---------------------------#
                machine_details = {}
                   data = {}
                  data[:time_difference] = []
               data[:time_difference_seconds] = []
                  final_data=[];
          unless machine_log.count == 0
           final = []
           frst = machine_log[0].machine_status
           machine_log.map do |ll|
            if ll.machine_status == frst
              final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
            else
             final << "$$"
             final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
             frst = ll.machine_status
            end
           end
           aa = final.split("$$")
           bb=[]
           aa.map {|ss| bb << [ss[0],ss[-1]]}
           rr = bb.map{|ll| ll.flatten}
           machine_details[:machine_status_report] = []
           rr.map do |ll|
            machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}
           end
           machine_details[:machine_status_report].map do |data|
            data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
            data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
           end
           @total_stop_time=machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk|  kk[:time_difference_seconds]}.sum
         end
#-----------------------------------------------------------------------#
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                  parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                  parts_last = (controller_part.to_i)
                   #downtime1 = (downtime != nil && @total_stop_time != nil) ? (downtime > 0 && @total_stop_time > 0 ) ? downtime - @total_stop_time : 0 : 0
                 #idle_time1 = (idle_time != nil && @total_stop_time != nil) ? (idle_time > 0 && @total_stop_time > 0 ) ? idle_time - @total_stop_time : 0 : 0
                   # downtime1 = downtime - @total_stop_time
                     data = {
                      #:cycle_time=> parts_count.to_i > 0 ? machine_log.where(:parts_count=>machine_log.last.parts_count - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count ).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0,
                      #:cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
                       :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last - 1).present? ? Time.at(machine_log.where(:parts_count=>parts_last - 1).last.run_time*60 + machine_log.where(:parts_count=>parts_last - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") :  Time.at(machine_log.where(:parts_count=>parts_last).last.run_time*60 + machine_log.where(:parts_count=>parts_last).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : "00:00:00",
                      :total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      :idle_time=> idle_time != nil ?  idle_time > 0 ? Time.at(idle_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :total_stop_time=> @total_stop_time != nil ? @total_stop_time > 0 ? Time.at(@total_stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :downtime=> downtime !=nil ? downtime > 0 ? Time.at(downtime).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :shift_no =>shift.shift_no,
                      :last_update=>mac.machine_logs.last.present? ? mac.machine_logs.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                      :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
                      :machine_id=>mac.id,
                      :machine_name=>mac.machine_name,
                      :job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
                      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? "O"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
                      :parts_count=>parts_count,
                      #:machine_status=>machine_log.last.present? ? machine_log.last.machine_status : nil,
                :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                      :utilization=>utilization.round(),
                      :total_load_unload_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                      :controller_part=>controller_part,
                      :start_time=>start_time
                    }

      #end
  end
end


#----------------------------------only 5 machine full dashboard data -----------------------------#
def self.dashboard_process(params)
  
    tenant=Tenant.find(params[:tenant_id])
    if tenant.machines != []
    shift = Shifttransaction.current_shift(tenant.id)
     if shift != nil
    date = Date.today.to_s


              if params[:type] == "Alarm"
                 tenant.machines.order(:id).map do |mac|
               data ={
                unit:mac.unit,
                date:date,
                :machine_id=>mac.id,
                :machine_name=>mac.machine_name,
                :alarm=>mac.alarms.last,
                :alarm_time=>mac.alarms.last.present? ? mac.alarms.last.updated_at.localtime.strftime("%I:%M %p") : nil,
                :alarm_date=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%d") : nil,
                :alarm_month=>mac.alarms.last.present? ? Date::MONTHNAMES[mac.alarms.last.updated_at.strftime("%m").to_i] : nil,
                :alarm_year=>mac.alarms.last.present? ? mac.alarms.last.updated_at.strftime("%Y") : nil
               }
            end
         else
          if shift != []
   date = Date.today.to_s
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        if Time.now.strftime("%p") == "AM"
          date = Date.today - 1
        end
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date +" "+shift.shift_end_time).to_time + 1.day
    else
       start_time = (date+" "+shift.shift_start_time).to_time
       end_time = (date+" "+shift.shift_end_time).to_time
    end
          total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
          actual_working_time = Time.now - shift.shift_start_time.to_time
             tenant.machines.order(:id).map do |mac|
                machine_log = mac.machine_daily_logs.where("created_at >=? AND created_at <?",start_time,end_time).order(:id)
                total_shift_time_available_for_downtime =  Time.now - start_time
                unless machine_log.present?
                 downtime = 0
                else

                  parts_count = Machine.parts_count_calculation(machine_log)
                   total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime
                   total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model
                   if mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).present?
                    entry_data_run_time = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:run_time).sum
                    total_run_time = total_run_time + entry_data_run_time
                    entry_parts = mac.data_loss_entries.where("created_at >?",start_time).where(entry_status:true).pluck(:parts_produced).sum

                    parts_count = parts_count + entry_parts.to_i
                   end

                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name|
                   job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0
                       part_split_job = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).split("0")
                          part_count_job=[]
                        part_split_job.uniq.map do |part|
                    unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split_job[0].empty?
                              part_count_job << part[-1].to_i
                              else
                             part_count_job << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count_job << part[-1].to_i
                        end
                      elsif part_split_job.index(part) != 0 && part[0] != machine_log.first.parts_count
                          part_count_job << part[0].to_i
                      end
                     end
                    end
                      else
                        part_count_job = 0
                      end
                     part_count_job = part_count_job.select(&0.method(:<)).sum < 0 ? 0 : part_count_job.select(&0.method(:<)).sum
                    parts_count_splitup << {:job_name=>job_name,:part_count=>part_count_job}
                   end
                    all_jobs = machine_log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                    total_load_unload_time=[]
                    all_jobs.map do |job|
                    job_wise_load_unload = []
                    job_part = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part_load_unload = machine_log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                    job_part_load_unload.shift if job_part_load_unload[0] == "0" || job_part_load_unload[0] == machine_log.first.parts_count
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1
                    job_wise_load_unload = machine_log.where(parts_count:job_part).where(programe_number:job).group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                    unless job_wise_load_unload.min.nil?
                        total_load_unload_time << job_wise_load_unload.min*job_part_load_unload.count
                    end
                   end
                    total_load_unload_time = total_load_unload_time.sum
                   cutting_time = (machine_log.last.total_cutting_time.to_i - machine_log.first.total_cutting_time.to_i)*60
                   total_shift_time_available = ((total_shift_time_available/60).round())*60
                   downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                  end
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  utilization = utilization.nil? ? 0 : utilization
                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                  #-----------------------------------stop time---------------------------#
                machine_details = {}
                   data = {}
                  data[:time_difference] = []
               data[:time_difference_seconds] = []
                  final_data=[];
          unless machine_log.count == 0
           final = []
           frst = machine_log[0].machine_status
           machine_log.map do |ll|
            if ll.machine_status == frst
              final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
            else
             final << "$$"
             final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
             frst = ll.machine_status
            end
           end
           aa = final.split("$$")
           bb=[]
           aa.map {|ss| bb << [ss[0],ss[-1]]}
           rr = bb.map{|ll| ll.flatten}
           machine_details[:machine_status_report] = []
           rr.map do |ll|
            machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}
           end
           machine_details[:machine_status_report].map do |data|
            data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
            data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
           end
           @total_stop_time=machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk|  kk[:time_difference_seconds]}.sum
         end
#-----------------------------------------------------------------------#
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                  parts_count = parts_count.to_i < 0 ? 0 : parts_count.to_i
                        parts_last = (controller_part.to_i)
                       downtime_split = (downtime - @total_stop_time)
                       idle_time_split = (idle_time - @total_stop_time)
                    data = {
                      :unit=>mac.unit,
                      :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last - 1).present? ? Time.at(machine_log.where(:parts_count=>parts_last - 1).last.run_time*60 + machine_log.where(:parts_count=>parts_last - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") :  Time.at(machine_log.where(:parts_count=>parts_last).last.run_time*60 + machine_log.where(:parts_count=>parts_last).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : "00:00:00",
                      :total_run_time=>total_run_time != nil ? Time.at(total_run_time).utc.strftime("%H:%M:%S") : "00:00:00",
                      :idle_time=> idle_time_split != nil ?  idle_time_split.abs > 0 ? Time.at(idle_time_split.abs).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :total_stop_time=> @total_stop_time != nil ? @total_stop_time > 0 ? Time.at(@total_stop_time).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                     # :downtime=> downtime !=nil ? downtime > 0 ? Time.at(downtime).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00",
                      :downtime=>downtime_split !=nil ? downtime_split > 0 ? Time.at(downtime_split.abs).utc.strftime("%H:%M:%S") : "00:00:00" : "00:00:00", 

                      :shift_no =>shift.shift_no,
                      :last_update=>mac.machine_logs.last.present? ? mac.machine_logs.order(:id).last.created_at.in_time_zone("Chennai") : 0,
                      :day_start=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai") : 0,
                    #.strftime("%I:%M %P") : 0,
                      :machine_id=>mac.id,
                      :machine_name=>mac.machine_name,
                      :job_name => mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.present? ? "O"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.programe_number+"-"+mac.machine_daily_logs.where.not(:job_id=>"",:programe_number=>nil).order(:id).last.job_id : nil ,
                      :parts_count=>parts_count,
#                      :downtime=> Time.at(downtime).utc.strftime("%H:%M:%S"),
                    #  :machine_status=>machine_log.last.present? ? machine_log.last.machine_status : nil,
                      :machine_status=>machine_log.last.present? ? (Time.now - machine_log.last.created_at) > 600 ? nil : machine_log.last.machine_status : nil,
                      :utilization=>utilization.round(),
                      :spindle_speed=>machine_log.last.present? ? machine_log.last.spindle_speed : nil,
                      :spindle_load=>machine_log.last.present? ? machine_log.last.spindle_load : nil,
                      :feed_rate=>machine_log.last.present? ? machine_log.last.feed_rate : nil,
                      :cutting_time=>cutting_time,
                      :total_load_unload_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
                      :controller_part=>controller_part,
                      :report_from=>machine_log.first.present? ? machine_log.first.created_at.in_time_zone("Chennai").strftime("%d/%m/%Y %I:%M %p") : nil,
                      :job_wise_part=>parts_count_splitup.nil? ? nil : parts_count_splitup.uniq ,
                      :entry_alert => mac.data_loss_entries.where("created_at >?",start_time).present? ? true : false,
                      :start_time=>start_time
                    }
      end
        else
         data = { message:"No shift Currently Avaliable" }
      end
  end
end
end
end
#------------------------------------------------------------------#