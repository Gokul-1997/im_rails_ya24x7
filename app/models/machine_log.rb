require 'active_support'
class MachineLog < ApplicationRecord
  belongs_to :machine, -> { with_deleted }
  belongs_to :cncjob ,optional:true
   serialize :x_axis, Array
  serialize :y_axis, Array
  serialize :cycle_time_minutes, Array

 def self.machine_process(params) 
    
 machine = Machine.find(params[:machine_id])
 date = params[:date].present? ? params[:date] : Date.today.to_s
 if params[:shifttransaction_id].present? && params[:shifttransaction_id] != "0"
  shift = Shifttransaction.find params[:shifttransaction_id]
 elsif params[:shifttransaction_id] == "0"
     start_time = (date+" "+machine.tenant.shift.day_start_time).to_time
     end_time = (date+" "+machine.tenant.shift.day_start_time).to_time + 1.day
     total_shift_time_available = Time.parse(machine.tenant.shift.working_time).seconds_since_midnight
 else
     shift = Shifttransaction.current_shift(machine.tenant.id) 
  end
 
  if shift.present?
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
    elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        start_time = (date+" "+shift.shift_start_time).to_time + 1.day
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      else
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time 
      end
    end
    
    if  params[:date].present? ? params[:date] : Date.today.to_s
    machine_log = machine.machine_daily_logs.where("created_at >= ? AND created_at <=?",start_time,end_time).order(:id)
  else
    machine_log = machine.machine_daily_logs.where("created_at >= ? AND created_at <=?",start_time,end_time).order(:id)
  end
   total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight if shift.present?

 total_shift_time_available_for_downtime =  Time.now - start_time
               part_count=[]
                #  part_split = machine_log.where.not(parts_count:"-1").pluck(:parts_count).split("0").reject{|i| i==[]}.map{|i| i.uniq}#machine_log.where.not(parts_count:"-1").pluck(:parts_count).uniq.split("0")
                  part_split = machine_log.where.not(parts_count:"-1").pluck(:parts_count).split("0").reject{|i| i.empty?}
                  part_split.map do |part|
                    
                   unless part==[]
                     if part.count!=1 # may be last shift's parts
                        if part[0].to_i > 1 # countinuation of last part
                           if part_split[0].empty?
                              part_count << part[-1].to_i
                           else 
                             part_count << part[-1].to_i - part[0].to_i
                           end
                        else
                          part_count << part[-1].to_i
                        end
                      elsif part_split.index(part) != 0 && part[0] != machine_log.first.parts_count
                          part_count << part[0].to_i
                      end
                     end
                   end
                   parts_count = part_count.sum

                             if !machine_log.where.not(parts_count:"-1").empty?
                    total_run=[]
                   #total_run_time = machine_log.where.not(parts_count:"-1").pluck(:total_run_time).uniq.include?(0) ? machine_log.where.not(parts_count:"-1").last.total_run_time*60 : (machine_log.where.not(parts_count:"-1").last.total_run_time - machine_log.where.not(parts_count:"-1").first.total_run_time)*60
                      tot_run = machine_log.where.not(parts_count:"-1").pluck(:total_run_time)
                      tot_run = tot_run.include?(0) ? tot_run.split(0).reject{|i| i.empty?} : tot_run.split(tot_run.min).reject{|i| i.empty?} 

                      tot_run.map do |run|
                          total_run << (run[-1] >= run[0] ?  run[-1] - run[0] : run[-1])
                      end
                      total_run_time = (total_run.sum)*60
                 else
                  total_run_time = 0
                 end

                       parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil? || i == "0"}.map do |j_name| 
                   job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                        #if machine_log.where.not(parts_count:"-1").where(:program e_number=>j_name).pluck(:parts_count).uniq.include?("0")
                          part_count =machine_log.where.not(parts_count:"-1").where(:programe_number=>"131").pluck(:parts_count).split("0").reject{|i| i==[]}.map{|i| i.uniq}.flatten.count  # machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                        #else
                         # part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count 
                        #end
                      else
                        part_count = 0
                      end
                    parts_count_splitup << {:job_name=>job_name,:part_count=>parts_count}
                   end
             
                 downtime = (total_shift_time_available_for_downtime - total_run_time).round()
                 utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                utilization = utilization.nil? ? 0 : utilization


    #==================
     all_shift= machine.tenant.shift.shifttransactions.pluck(:id,:shift_no).map{|i| i[1] ={:id=>i[0],:name=>"Shift_"+i[1].to_s}}
      all_shift << {:id=>0,:name=>"All"}
     shift_no = shift.present? ? shift.shift_no : machine.tenant.shift.shifttransactions.pluck(:shift_no).split(",").join(" & ")
      
      target_parts_total=MachineDailyLog.target_parts(params)
      
      data = {
        :shifts=>all_shift,
        :parts_count=>parts_count,
        :part_split=>parts_count_splitup, 
        :utilization=>utilization.round(),
        :efficiency=>target_parts_total == nil ? 0 : target_parts_total[:efficiency] ,
        :quality=>100,
        :oee_report=>target_parts_total == nil ? 0 : ((utilization*target_parts_total[:efficiency]*100)/10000).round(),
        :shift_no=>shift_no,
        :time=>start_time.strftime("%I:%M %p")+ "-" +end_time.strftime("%I:%M %p")
      }
    end


def self.stopage_time_details(params)
    date = params[:date].present? && params[:date] != "undefined"  ? params[:date] : Date.today.to_s
    machine = Machine.find(params[:machine_id])

    if params[:shifttransaction_id].nil? || params[:shifttransaction_id] == "null" || params[:shifttransaction_id] == "0" || params[:shifttransaction_id] == "undefined"
      #unless params.include?("shifttransaction_id")
      start_time = (date+" "+machine.tenant.shift.day_start_time).to_time
      end_time = (date+" "+machine.tenant.shift.day_start_time).to_time + 1.day
      end_time_for_ideal = Time.now < end_time ? Time.now : end_time
      time_range = start_time..end_time
    else
      shift = Shifttransaction.find(params[:shifttransaction_id]) 
      if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        start_time = (date+" "+shift.shift_start_time).to_time + 1.day
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      else
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time 
      end
      end_time_for_ideal = Time.now < end_time ? Time.now : end_time
      time_range = start_time..end_time
    end
    if params[:date].present? && params[:date] == "undefined" || date == Date.today.to_s
      total_data = machine.machine_daily_logs.where(created_at: start_time..end_time).order(:id)
    elsif params[:date].present? && params[:date].to_date.strftime("%m")==Date.today.strftime("%m") 
       total_data = machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    else
      total_data = machine.machine_logs.where(created_at: start_time..end_time).order(:id)
    end
    #total_data1 = machine.machine_logs.where(created_at: start_time..date+" "+Time.now.strftime("%I:%M %p")).order(:id)

    parts_count = Machine.parts_count_calculation(total_data)
    
    machine_details = {}
    machine_details[:machine_status_report] = []
    machine_details[:downtime] = []
    machine_details[:production] = []
    machine_details[:runtime] = []
    machine_details[:stoptime] = []
    machine_details[:job_details] = {}
    machine_details[:data_status] = total_data.empty? ? false : true
   

      machine_details[:job_details][:parts_produced] = parts_count.to_i < 0 ? 0 : parts_count.to_i#total_data.where.not(parts_count:"-1").present? ? total_data.where.not(parts_count:"-1").pluck(:parts_count).uniq.reject{|i| i == "0"}.count : 0
      machine_details[:job_details][:rejects] = 0
      machine_details[:job_details][:rework] = 0
      machine_details[:job_details][:inspection] = 0
      machine_details[:job_details][:remaining_parts] = 0
      machine_details[:job_details][:parts_delivered] = 0

    bb=[];kk=[];
    hourinterval = []
    
    (start_time.to_i..end_time.to_i).step(3600){|pp| hourinterval << Time.at(pp).localtime}
    hourinterval << end_time
    final_data=[];
    unless total_data.count == 0
      final = []
      frst = total_data[0].machine_status
      total_data.map do |ll|
        
        if ll.machine_status == frst
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          final << "$$"
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
          frst = ll.machine_status
        end
      end
      aa = final.split("$$")
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}
        
      rr.map do |ll|
        
        machine_details[:machine_status_report] << {:start_time=>ll[0],:end_time=>ll[4],:status=>ll[1]}
      end

      machine_details[:machine_status_report].map do |data|
        
         data[:time_difference] = (data[:end_time].to_time - data[:start_time].to_time).round()/60
         data[:time_difference_seconds] = (data[:end_time].to_time - data[:start_time].to_time).round()
      end
      firsthr = hourinterval[0]
      l=0
      time_split=[]
      
      hourinterval.map { |time| time_split <<{:time_details=>time.strftime("%I:%M %p")+"-"+(time+1.hour).strftime("%I:%M %p")} }

      time_split.pop
      hourinterval.map do |hr|
        next if firsthr == hr
        l=l+1
        hrdata = total_data.where(:created_at=>firsthr..hr)
        start_parts_count = l < 1 ? 0 : hrdata.where.not(parts_count:"-1").first.parts_count if hrdata.where.not(parts_count:"-1").present?
        end_parts_count = hrdata.where.not(parts_count:"-1").last.parts_count if hrdata.where.not(parts_count:"-1").present?
        
        if start_parts_count.to_i > end_parts_count.to_i
          start_parts_count = 0
        else
          start_parts_count = start_parts_count
        end
       
        parts_count = end_parts_count.to_i - start_parts_count.to_i

        hrdowntime = hrdata.map{|mclog| mclog.machine_status == 0 ? mclog.created_at : "***"   }
        hrruntime = hrdata.map{|mc1log| mc1log.machine_status == 3 ? mc1log.created_at : "***" }
        hrstoptime = hrdata.map{|mc2log| mc2log.machine_status == 100 ? mc2log.created_at : "***" }
        downtime = hrdowntime.split("***").map{|dwntime| (dwntime[-1] - dwntime[0]).to_i/60 unless dwntime.empty?}.compact.sum
        runtime  = hrruntime.split("***").map{|rntime| (rntime[-1] - rntime[0]).to_i/60 unless rntime.empty?}.compact.sum
        stoptime = hrstoptime.split("***").map{|stptime| (stptime[-1] - stptime[0]).to_i/60 unless stptime.empty?}.compact.sum
        machine_details[:downtime] << {"time": hr.strftime("%H:%M %p"), "downtime": downtime}#Time.at(downtime).utc.strftime("%H:%M:%S")}
        machine_details[:production] << {"time": hr.strftime("%H:%M %p"), "parts_count": parts_count}#
        machine_details[:runtime]  << {"time": hr.strftime("%H:%M %p"), "runtime": runtime}#Time.at(runtime).utc.strftime("%H:%M:%S")}
        machine_details[:stoptime] <<  {"time": hr.strftime("%H:%M %p"), "stoptime": stoptime}#Time.at(stoptime).utc.strftime("%H:%M:%S")}
        firsthr = hr
      end
       tot_run_time = Machine.calculate_total_run_time(total_data)
       
       machine_details[:total_run_time]=Time.at(tot_run_time).utc.strftime("%H:%M:%S")
       
       machine_details[:total_stop_time]=Time.at(machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum).utc.strftime("%H:%M:%S")
       stop_time = machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum
          tot_ideal_time = ((end_time_for_ideal-start_time)-tot_run_time)-stop_time
       machine_details[:total_ideal_time]=tot_ideal_time < 0 ? "00:00:00" : Time.at(tot_ideal_time).utc.strftime("%H:%M:%S")
       machine_details[:start_time]=start_time.strftime("%I:%M %p")
       machine_details[:end_time]=end_time.strftime("%I:%M %p")
       machine_details[:remaining_time]=Time.at((end_time-start_time)-(Time.parse(machine_details[:total_run_time]).seconds_since_midnight+Time.parse(machine_details[:total_ideal_time]).seconds_since_midnight+Time.parse(machine_details[:total_stop_time]).seconds_since_midnight)).utc.strftime("%H:%M:%S")
       machine_details[:time_split]=time_split

=begin
       tot_run_time = total_data.pluck(:total_run_time).uniq.reject{|ii| ii == 0}.count*60
       entry_run_time = machine.data_loss_entries.where("created_at >? AND created_at <?",start_time,end_time).where(entry_status:true).pluck(:run_time).sum
       entry_ideal_time = machine.data_loss_entries.where("created_at >? AND created_at <?",start_time,end_time).where(entry_status:true).pluck(:downtime).sum*60
       machine_details[:total_run_time]=Time.at(tot_run_time+entry_run_time).utc.strftime("%H:%M:%S")
       machine_details[:total_stop_time]=Time.at(machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum).utc.strftime("%H:%M:%S")
       stop_time = machine_details[:machine_status_report].select{|ll| ll[:status]=="100" }.map{|kk| a= kk[:time_difference_seconds]}.sum
       machine_details[:total_ideal_time]=Time.at(((end_time-start_time)-tot_run_time)+entry_ideal_time-stop_time).utc.strftime("%H:%M:%S")
       machine_details[:start_time]=start_time.strftime("%I:%M %p")
       machine_details[:end_time]=end_time.strftime("%I:%M %p")
       machine_details[:remaining_time]=Time.at((total_time)-(Time.parse(machine_details[:total_run_time]).seconds_since_midnight+Time.parse(machine_details[:total_ideal_time]).seconds_since_midnight+Time.parse(machine_details[:total_stop_time]).seconds_since_midnight)).utc.strftime("%H:%M:%S")
       machine_details[:time_split]=time_split
=end
      #machine_details[:hour_interval] = hourinterval.map{|hour| }
    end
    return machine_details
  end

 def self.hour_wise_status(params)
  
     date = params[:date].present? && params[:date] != "undefined"  ? params[:date] : Date.today.to_s
    machine = Machine.find(params[:machine_id])
    if params[:shifttransaction_id].nil? || params[:shifttransaction_id] == "null" || params[:shifttransaction_id] == "0" || params[:shifttransaction_id] == "undefined"
      start_time = (date+" "+machine.tenant.shift.day_start_time).to_time
      end_time = (date+" "+machine.tenant.shift.day_start_time).to_time + 1.day
      #time_range = start_time..end_time
    else
      shift = Shifttransaction.find(params[:shifttransaction_id]) 
      if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        start_time = (date+" "+shift.shift_start_time).to_time + 1.day
         end_time = (date+" "+shift.shift_end_time).to_time + 1.day
      else
         start_time = (date+" "+shift.shift_start_time).to_time
         end_time = (date+" "+shift.shift_end_time).to_time 
      end
      #time_range = start_time..end_time
    end
    if params[:date].present? && params[:date] == "undefined" || params[:date] == Date.today.to_s || params[:date] == ""
       machine_log = machine.machine_daily_logs.where(created_at: start_time..end_time).order(:id)
   elsif params[:date].present? && params[:date].to_date.strftime("%m")==Date.today.strftime("%m") 
       machine_log = machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    else
       machine_log = machine.machine_logs.where(created_at: start_time..end_time).order(:id)
    end

 
   # ======================================#

    hour_split=[]
    (start_time.to_i..end_time.to_i).step(3600){|pp| hour_split << Time.at(pp).localtime}
    #hour_split << end_time
     last_hour = hour_split.count 
     firsthr1 = hour_split[0]
      l=0
      time_split1=[]
      
      #hour_split.map { |time| time_split1 <<{:time_details=>time.strftime("%I:%M %p")+"-"+(time+1.hour).strftime("%I:%M %p")} }

    #  time_split1.pop
    hour_split.map do |hour|
   #next if firsthr1 == hour
        l=l+1
     total_data = machine_log.where(created_at: hour..hour+1.hour).order(:id)
      unless total_data.count == 0
      final = []
      frst = total_data[0].machine_status
    bb = [] 
      total_data.map do |ll|
           if ll.machine_status == frst
              final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status]

           else
             final << "$$"
             final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status]
             frst = ll.machine_status
           end
      end
      
#------- parts count hr -----------#
          start_parts_count1 = l < 1 ? 0 : total_data.where.not(parts_count:"-1").first.parts_count if total_data.where.not(parts_count:"-1").present?
        end_parts_count1 = total_data.where.not(parts_count:"-1").last.parts_count if total_data.where.not(parts_count:"-1").present?
        
        if start_parts_count1.to_i > end_parts_count1.to_i
         start_parts_count1 = 0
        else
          start_parts_count1 = start_parts_count1
        end
        parts_count = end_parts_count1.to_i - start_parts_count1.to_i
#-----------------------------------#

      aa = final.split("$$")
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}

     total_run_time = Machine.calculate_total_run_time(total_data)

     if params[:machine_status] == "3"
      
      total_time = total_run_time
     elsif params[:machine_status] == "100"
      total_time = rr.select{|kk| kk[1] == "100"}.map{|ff| ff[2].to_time - ff[0].to_time}.sum
     else
      stop_time = rr.select{|kk| kk[1] == "100"}.map{|ff| ff[2].to_time - ff[0].to_time}.sum
      total_time = (3600 - total_run_time) - (stop_time+(total_data[0].created_at-hour+(hour+1.hour-total_data.last.created_at)))
     end
     end
     total_time = total_time.nil? || total_time < 0 ? 0 : total_time

     unless end_time == hour
      
      data = {
        :hour => hour == hour_split.last ? hour.strftime("%I:%M %p")+"-"+(end_time).strftime("%I:%M %p") : hour.strftime("%I:%M %p")+"-"+(hour+1.hour).strftime("%I:%M %p") ,
        :total_time => Time.at(total_time).utc.strftime("%H:%M:%S"),
        :status => params[:machine_status],
        :parts_count=> parts_count.nil? ? 0 : parts_count
      }
    end
  end
end

  def self.machine_page_job_details_portal(params)
    machine = Machine.find(params[:machine_id])
    data = params[:shifttransaction_id].present? ? machine.machine_logs.where("created_at <= ? AND created_at >= ?", Shifttransaction.find(params[:shifttransaction_id]).shift_start_time.to_time,Shifttransaction.find(params[:shifttransaction_id]).shift_end_time.to_time) : machine.machine_logs.where("created_at >=?",machine.tenant.shift.day_start_time.to_time)
    if data.present?
      parts_count = data.where.not(parts_count:"-1").last.present? ? data.where.not(parts_count:"-1").last.parts_count : 0
      job_data = {
        :parts_count=>parts_count
      }
    end
  end
  
  def self.job_details(params)
    operation_parts = []
    job = Cncjob.find(params[:job_id])
    operation_names = job.cncoperations.pluck(:operation_no)
    job_operations = job.cncoperations
    order_quantity = job.order_quantity
    job_start_date = job.job_start_date
    job_end_date = job.job_due_date
    operation_numbers = job_operations.pluck(:operation_no)
    machine_log = MachineLog.where(job_id:operation_names)
    operation_numbers.map{|no| operation_parts << machine_log.where(job_id:no).where.not(parts_count:"-1").order(:id).last.parts_count.to_i}
    operation_data = operation_numbers.map{|pp| {:operation_parts_produced=>machine_log.where(job_id:pp).where.not(parts_count:"-1").order(:id).last.parts_count,:order_quantity=>order_quantity}}
    parts_produced = operation_parts.empty? ?  0 : operation_parts.min
    parts_remaining = order_quantity - parts_produced
    data = {
      :job_name=>job.job_id,
      :job_operations=>job_operations,
      :order_quantity=>order_quantity,
      :job_start_date=>job_start_date,
      :job_end_date=>job_end_date,
      :parts_produced=>parts_produced,
      :parts_remaining=>parts_remaining,
      :operation_data=>operation_data
    }
    return data
  end

  
  def self.oee_calculation(params)
    oee = []
     tenant = Tenant.find(params[:tenant_id])
     date = params[:date].present? ? params[:date] : Date.today.to_s
     if params[:shifttransaction_id].present?
        shift = Shifttransaction.find(params[:shifttransaction_id])
        shift_lenght = (shift.shift_end_time.to_time.seconds_since_midnight - shift.shift_end_time.to_time.seconds_since_midnight).round()/60
        break_minute = shift.break_times.pluck(:total_minutes).map(&:to_i).sum
        planed_production_time = shift_lenght - break_minute
        oee_entries = OperatorEntryOee.where("created_at >? AND created_at <?",(date+" "+shift.shift_start_time).to_time,(date+" "+shift.shift_end_time).to_time)  
     else
      shift_lenght = 24*60
      break_minute = BreakTime.where(shifttransaction_id:tenant.shift.shifttransactions.ids).pluck(:total_minutes).map(&:to_i).sum
      planed_production_time = shift_lenght - break_minute
      oee_entries = OperatorEntryOee.where("created_at >? AND created_at <?",(date+" "+tenant.shift.day_start_time).to_time,((date+" "+tenant.shift.day_start_time).to_time - 1.minute) + 1.day)  
     end
      oee_entries.pluck(:cncoperation_id).uniq.map do |ff|
        downtime = oee_entries.where(cncoperation_id:ff).pluck(:downtime).map(&:to_i).sum
        total_pices = oee_entries.where(cncoperation_id:ff).pluck(:total_part).map(&:to_i).sum
        idle_run_rate = oee_entries.where(cncoperation_id:ff)[0].idle_run_time
        reject_pices = oee_entries.where(cncoperation_id:ff).pluck(:reject_part).map(&:to_i).sum
        operating_time = planed_production_time - downtime
        good_pices = total_pices - reject_pices
        availablity = (operating_time/planed_production_time)*100
        performance = ((total_pices/operating_time)/idle_run_rate)*100
        quality = (good_pices/total_pices)*100
        oee << (availablity*performance*quality/1000000)*100
      end
      oee_final = oee.map(&:to_f).sum
  end


  def self.month_reports
    
    tenant_active=Tenant.where(isactive: true).ids
    #start_date= Date.today.beginning_of_month - 1.month
    #end_date= Date.today.end_of_month - 1.month
    start_date= Date.yesterday
    end_date= Date.today
        tenant_active.map do |tenant_i|
           @data=[]
        #date = params[:start_date]
        tenant=Tenant.find(tenant_i)
        #tenant=Tenant.where(isactive: true)
        machines= tenant.machines 
        shiftstarttime=tenant.shift.day_start_time
        #if params[:report_type] == "Shiftwise"
        (start_date..end_date).map(&:to_s).map do |date|
        shifts = tenant.shift.shifttransactions
        shifts.map do |shift|
              if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
                     start_time = (date+" "+shift.shift_start_time).to_time
                     end_time = (date+" "+shift.shift_end_time).to_time+1.day        
              elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
                     start_time = (date+" "+shift.shift_start_time).to_time+1.day
                     end_time = (date+" "+shift.shift_end_time).to_time+1.day
              else
                    start_time = (date+" "+shift.shift_start_time).to_time
                    end_time = (date+" "+shift.shift_end_time).to_time        
              end
              end_time_for_ideal = Time.now < end_time ? Time.now : end_time
        total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight
        machines.order(:id).map do |mac|
        machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
        #machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
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
        #downtime = (total_shift_time_available_for_downtime - total_run_time).round()
           downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
        job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
        end

        total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
        utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
        #total_shift_time_available = total_shift_time_available + break_minute if downtime < 0
        utilization = utilization.nil? ? 0 : utilization
        #operator_name = shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.present? ? shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_name+"-"+shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.created_at.strftime("%D %I:%M %p") : "Not Assigned"
        #operator_id = shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.present? ? shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_spec_id : "Not Assigned"
        operator_name = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : "Not Assigned"
        operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_spec_id : "Not Assigned"
        total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time

        #idle_time = downtime - total_load_unload_time
        idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
        total_run_time = total_run_time.nil? ? 0 : total_run_time
        targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
        controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
        parts_count = parts_count.to_i < 0 ? controller_part : parts_count
        #parts_count = parts_count.to_i.nil? ? 0 : parts_count
        parts_last = (controller_part.to_i)
        operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0

          @data << [date,
                    shift.shift_no,
                    shift.shift_start_time+' - '+shift.shift_end_time,
                    operator_name,
                    operator_id,
                    mac.machine_name,
                    mac.machine_type,
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
                    utilization.nil? || utilization < 0 ? 0 : utilization.round()
          ]
          
        end
        end
        
    end
     path="#{Rails.root}/public/#{tenant.tenant_name+"-"+start_date.strftime("%B")}.csv"
      CSV.open(path,"wb") do |csv|
        # csv << ["date","time","shift_no","machine_name","machine_type","idle_time","downtime","total_load_unload_time","parts_count","utilization","operator_name","operator_id","programe_number","job_description","targeted_parts","total_run_time","operator_efficiency"]
        csv << ["Date","Shift","Time","Operator MFR","Operator ID","Machine Name" ,"Machine ID","Program Number","Job Description","Parts Produced(No's)","Cycle Time(M:S)","Loading and Unloading Time(Hrs)","Idle Time (Hrs)","Total Downtime(Hrs)","Actual Running(Hrs)","Actual Working Hours" ,"Utilization"]
         @data.map {|i| csv << i} 
      end 
         MonthReport.create(:date=>start_date,:tenant_id=>tenant.id,:file_path=>File.open(path, "rb"))
         FileUtils.rm(path)     
  end
end


  def self.reports(params)
     
  date = params[:start_date]
  tenant=Tenant.find(params[:tenant_id])
  machines=params[:machine_id].present? ? Machine.where(id:params[:machine_id]) : tenant.machines 
  shiftstarttime=tenant.shift.day_start_time

if params[:report_type] == "Shiftwise"

  (params[:start_date].to_date..params[:end_date].to_date).map(&:to_s).map do |date|
    
    shifts = params[:shift_id].present? ? Shifttransaction.where(id:params[:shift_id]) : tenant.shift.shifttransactions
  shifts.map do |shift|
    if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time+1.day        
    elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
        start_time = (date+" "+shift.shift_start_time).to_time+1.day
        end_time = (date+" "+shift.shift_end_time).to_time+1.day
    else
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time        
    end
 
     end_time_for_ideal = Time.now < end_time ? Time.now : end_time
     total_shift_time_available = Time.parse(shift.actual_working_hours).seconds_since_midnight     
             machines.order(:id).map do |mac|
            
              if params[:start_date] == Date.today.to_s && params[:end_date] == Date.today.to_s  
               machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id) 
              elsif params[:start_date].to_date.strftime("%m")==Date.today.strftime("%m") && params[:end_date].to_date.strftime("%m")==Date.today.strftime("%m")
                  machine_log = mac.machine_monthly_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id) 
              elsif params[:start_date].to_date.strftime("%m")==Date.today.months_ago(1).strftime("%m") && params[:end_date].to_date.strftime("%m")==Date.today.months_ago(1).strftime("%m")
                  machine_log = mac.pre_monthly_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              else
               machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              end
               #machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
              total_shift_time_available_for_downtime =  Time.now - start_time
              
                unless machine_log.present?
                 downtime = 0 
                else
          # not understand temp hidden
               #  time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - shift.shift_start_time.to_time.utc.seconds_since_midnight)/60
                
                   #if time_difference >= 10 
                   #   total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
                   #else
                  #    total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
                      
                   #end 
          # ---------------------------        
          
                  cycl = Machine.single_part_cycle_time(machine_log)
                
                  parts_count = Machine.parts_count_calculation(machine_log)#
                       
                  total_shift_time_available_for_downtime = total_shift_time_available_for_downtime < 0 ? total_shift_time_available_for_downtime*-1 : total_shift_time_available_for_downtime

                  total_run_time = Machine.calculate_total_run_time(machine_log)#Reffer Machine model                    
                
                   parts_count_splitup=[]
                   machine_log.pluck(:programe_number).uniq.reject{|i| i == "" || i.nil?}.map do |j_name| 
                   job_name = "O"+j_name
                      if machine_log.where.not(parts_count:"-1").where(programe_number:j_name).count != 0 
                        total_part=machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq
                          part_count = machine_log.where.not(parts_count:"-1").where(:programe_number=>j_name).pluck(:parts_count).uniq.reject{|i| i == "0"}.count - 1 
                          @cycle_time=[]
                          parts=[]
                          total_part.each do |part|
#                          
#                            parts << part
#                          cycle_time << Time.at(machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") 
             @cycle_time << {:parts=>part,cycle_time:Time.at(machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000).utc.strftime("%H:%M:%S")}
                        
              end

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
                  
                  operator_name = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_name : "Not Assigned"
                  operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  "Not Assigned" : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.operator_spec_id : "Not Assigned"
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
                   
                  cycle_time1 = @cycle_time.delete_at(-1)# if @cycle_time.present?
                  
        data = {
          :date=>date,
          :time=>shift.shift_start_time+' - '+shift.shift_end_time,
          :shift_no =>shift.shift_no, 
          :machine_name=>mac.machine_name,
          :machine_type=>mac.machine_type,
          :actual_working_hours=>shift.actual_working_hours,
          :cycl => cycl,
         # :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
          :cycle_time=>parts_count_splitup.nil? ? nil : @cycle_time ,
          :idle_time=>Time.at(idle_time).utc.strftime("%H:%M:%S"),
          :total_downtime=> Time.at(downtime).utc.strftime("%H:%M:%S"),
          :loading_and_unloading_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
          :parts_produced=>parts_count,
          :utilization=>utilization.nil? || utilization < 0 ? 0 : utilization.round(),
          :operator_name=>operator_name,
          :operator_id=>operator_id,
          :program_number=>machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
          :job_description=>job_description.nil? ? "-" : job_description.split(',').join(" & "),
          :targeted_parts => targeted_parts,
          :actual_running=>Time.at(total_run_time).utc.strftime("%H:%M:%S"),
          :operator_efficiency=>operator_efficiency
        }
      end
      
  end
end
elsif params[:report_type] == "Operatorwise"
      operator_id=params[:operator_id]
      
      date_include_operator=OperatorMappingAllocation.where(:date=>params[:start_date].to_date..params[:end_date].to_date,:operator_id=>  params[:operator_id])  
      machines.order(:id).map do |mac|
      date_include_operator.map do |operator_mapping_row| 
        
        shift_transaction= operator_mapping_row.operator_allocation.shifttransaction   
        machine_row = operator_mapping_row.operator_allocation.machine
        
         if shift_transaction.shift_start_time.include?("PM") && shift_transaction.shift_end_time.include?("AM")
             start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time
             end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time+1.day        
         elsif shift_transaction.shift_start_time.include?("AM") && shift_transaction.shift_end_time.include?("AM")
             start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time+1.day
             end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time+1.day
         else
             start_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_start_time).to_time
             end_time = ((operator_mapping_row.date).strftime("%F")+" "+shift_transaction.shift_end_time).to_time        
         end
             end_time_for_ideal = Time.now < end_time ? Time.now : end_time
             total_shift_time_available = Time.parse(shift_transaction.actual_working_hours).seconds_since_midnight
             machine_log = machine_row.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
    
          if params[:start_date] == Date.today.to_s && params[:end_date] == Date.today.to_s  
               machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id) 
          elsif params[:start_date].to_date.strftime("%m")==Date.today.strftime("%m") && params[:end_date].to_date.strftime("%m")==Date.today.strftime("%m")
               machine_log = mac.machine_monthly_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id) 
          else
               machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
          end


        unless machine_log.present?
                 downtime = 0
                else
          # not understand temp hidden
                 #time_difference = (machine_log.first.created_at.to_time.seconds_since_midnight - shift.shift_start_time.to_time.utc.seconds_since_midnight)/60
                
                   #if time_difference >= 10 
                   #   total_run_time = machine_log.last.total_run_time.nil? ? 0 : machine_log.last.total_run_time*60
                   #else
                    #   total_run_time = (machine_log.last.total_run_time.to_i - machine_log.first.total_run_time.to_i)*60
                   #end 
          # ---------------------------        
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

                       downtime =  ((end_time_for_ideal-start_time)-total_run_time).round()
                  job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
                end
                  total_shift_time_available = total_shift_time_available #- break_minute if machine_log.where.not(parts_count:"-1").count != 0
                  utilization =(total_run_time*100)/total_shift_time_available if machine_log.where.not(:parts_count=>"-1").count != 0# && machine_log.where.not(:machine_status=>"0").count != 0
                  total_shift_time_available = total_shift_time_available + break_minute if downtime < 0
                  utilization = utilization.nil? ? 0 : utilization
                  total_load_unload_time = total_load_unload_time.nil? ? 0 : total_load_unload_time
                   
                  idle_time = downtime - total_load_unload_time < 0 ? 0 : downtime - total_load_unload_time
                  total_run_time = total_run_time.nil? ? 0 : total_run_time
                  targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                  
                  parts_count = parts_count.to_i < 0 ? controller_part : parts_count.to_i
                  parts_last = (controller_part.to_i)
                  operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0

      data = {
          :date=>(operator_mapping_row.date).strftime("%F"),
          :time=>shift_transaction.shift_start_time+' - '+shift_transaction.shift_end_time,
          :shift_no =>shift_transaction.shift_no,
          :machine_name=>mac.machine_name,
          :machine_type=>mac.machine_type,
          :actual_working_hours=>shift_transaction.actual_working_hours,
          :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
         #:cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
          :idle_time=>Time.at(idle_time).utc.strftime("%H:%M:%S"),
          :total_downtime=> Time.at(downtime).utc.strftime("%H:%M:%S"),
          :loading_and_unloading_time=>Time.at(total_load_unload_time).utc.strftime("%H:%M:%S"),
          :parts_produced=>parts_count,
          :utilization=>utilization.nil? || utilization < 0 ? 0 : utilization.round(), 
          :operator_name=>operator_mapping_row.operator.operator_name,
          :operator_id=>operator_mapping_row.operator.operator_spec_id,
          :program_number=>machine_log.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | "),
          :job_description=>job_description.nil? ? "-" : job_description.split(',').join(" & "),
          :targeted_parts => targeted_parts,
          :actual_running=>Time.at(total_run_time).utc.strftime("%H:%M:%S"),
          :operator_efficiency=>operator_efficiency
             } 

      end  
    end

elsif params[:report_type] == "Datewise"
   (params[:start_date].to_date..params[:end_date].to_date).map(&:to_s).map do |date|
      start_date = (date+" "+tenant.shift.day_start_time).to_time
      machines.order(:id).map do |mac|
         total_day_time_available = 24*3600
        # machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_date,start_date+1.day).order(:id)
        if params[:start_date] == Date.today.to_s && params[:end_date] == Date.today.to_s  
               machine_log = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_date,start_date+1.day).order(:id) 
          elsif params[:start_date].to_date.strftime("%m")==Date.today.strftime("%m") && params[:end_date].to_date.strftime("%m")==Date.today.strftime("%m")
               machine_log = mac.machine_monthly_logs.where("created_at >= ? AND created_at <= ?",start_date,start_date+1.day).order(:id) 
          else
               machine_log = mac.machine_logs.where("created_at >= ? AND created_at <= ?",start_date,start_date+1.day).order(:id)
          end
         total_run_time=[]
         if machine_log.count !=0
=begin parts_count=[]
            machine_log.where.not(parts_count:"-1").pluck(:parts_count).split("0").reject{|i| i.empty?}.map do |pp|
              if pp.uniq[0].to_i > 1
               parts_count << pp.uniq[-1].to_i - pp[0].to_i 
             else
              parts_count << pp[-1].to_i
             end
            end
           parts_count = parts_count.sum
=end
          parts_count = Machine.parts_count_calculation(machine_log)#
           programe_number = machine_log.pluck(:programe_number).uniq.reject{|i| i.nil? || i == ""}
           job_description = machine_log.pluck(:job_id).uniq.reject{|i| i.nil? || i == ""}
           total_run_time = machine_log.pluck(:total_run_time).split(0).reject{|i| i.empty?}.map{|time| total_run_time = time[-1].to_i-time[0].to_i}.sum*60
           downtime = total_day_time_available - total_run_time
           utilization = total_run_time*100/total_day_time_available.round()
           shift_data=[]
           tenant.shift.shifttransactions.map do |shift|
            if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
               start_time = (date+" "+shift.shift_start_time).to_time
               end_time = (date+" "+shift.shift_end_time).to_time+1.day        
            else
               start_time = (date+" "+shift.shift_start_time).to_time
               end_time = (date+" "+shift.shift_end_time).to_time        
            end
            shift_data << mac.machinedaily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
          end
          total_load_unload=[]
          targeted_parts = []
          shift_data.map do |log|
                    all_jobs = log.where.not(parts_count:"-1").pluck(:programe_number).uniq.reject{|i| i == ""}
                    all_jobs.map do |job|
                    job_wise_load_unload = []
                    job_part = log.where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq.reject{|part| part == "0"}
                    job_part.shift
                    job_part.pop if job_part.count > 1 
                    job_part_load_unload = log.where(programe_number:job).where.not(parts_count:"-1").where(programe_number:job).pluck(:parts_count).uniq
                     if job_part_load_unload[0] == "0" || job_part_load_unload[0] == log.first.parts_count
                      job_part_load_unload.shift if job_part_load_unload[0].to_i > 1
                     end
                    job_part_load_unload = job_part_load_unload.reject{|i| i=="0"} 
                    job_wise_cycle_time = log.where(parts_count:job_part).where(programe_number:job).where.not(parts_count:"-1").group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at)}
                    job_wise_cycle_time = job_wise_cycle_time.reject{|i| i <= 0}
                    targeted_parts << (log.where(programe_number:job).where(parts_count:job_part[-1]).order(:id).last.created_at - log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).first.created_at)/job_wise_cycle_time.min if log.where(programe_number:job).where(parts_count:job_part[0]).order(:id).last.present? && !job_wise_cycle_time.min.nil?
                    job_wise_load_unload = log.where(parts_count:job_part).where(programe_number:job).where.not(parts_count:"-1").group_by(&:parts_count).map{|pp,qq| (qq.last.created_at - qq.first.created_at) - (qq.last.run_time*60 + qq.last.run_second.to_i/1000)}
                    job_wise_load_unload = job_wise_load_unload.reject{|i| i <= 0 }
                      unless job_wise_load_unload.min.nil?
                       total_load_unload << job_wise_load_unload.min*job_part_load_unload.count
                      end
                   end
          end
          total_load_unload = total_load_unload.sum
          targeted_parts = targeted_parts[0].to_s=="Infinity" ? 0 : targeted_parts.sum
     else
       total_run_time = 0
     end
          downtime = downtime.nil? ? 0 : downtime
          total_load_unload = total_load_unload.nil? ? 0 : total_load_unload
          idle_time = downtime - total_load_unload
          total_run_time = total_run_time.nil? ? 0 : total_run_time
          operator_name=[]
          operator_id=[]
        tenant.shift.shifttransactions.map do |shift|
            if shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.present?
              operator_name << shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_name+"-"+shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.created_at.strftime("%D %I:%M %p")
              operator_id << shift.operator_allocations.where(machine_id:mac.id).where("created_at >=? AND created_at <=?",date.to_date,date.to_date + 1.day).last.operator.operator_spec_id

            else
              operator_name << ["Not Assigned"]
              operator_id << ["Not Assigned"]
            end
         end
                  targeted_parts = targeted_parts.nil? ? 0 : targeted_parts.round()
                  controller_part = machine_log.where.not(parts_count:"-1").last.present? ? machine_log.where.not(parts_count:"-1").last.parts_count : 0
                  #parts_count = parts_count.nil? ? 0 : parts_count.to_i
                  parts_count = parts_count.to_i < 0 ? controller_part : parts_count.to_i
                  parts_last = (controller_part.to_i)
                  operator_efficiency = (parts_count*100/targeted_parts).round() unless targeted_parts == 0
                  
          data = {
            :date=>date,
            :time=>tenant.shift.day_start_time+' - '+(tenant.shift.day_start_time.to_time-1.minute).strftime("%I:%M %p"),
            :shift_no=>tenant.shift.shifttransactions.pluck(:shift_no).split(",").join(" & "),
            :machine_name=>mac.machine_name,
            :machine_type=>mac.machine_type,
            :actual_working_hours=>tenant.shift.shifttransactions.pluck(:actual_working_hours).split(",").join(" & "),
            :parts_count=>parts_count,
            #:cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).present? ? Time.at(machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_time*60 + machine_log.where(:parts_count=>machine_log.last.parts_count.to_i - 1).last.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
            :cycle_time=> parts_count.to_i > 0  ? machine_log.where(:parts_count=>parts_last).present? ? Time.at(machine_log.where(:parts_count=>parts_last).first.run_time*60 + machine_log.where(:parts_count=>parts_last).first.run_second.to_i/1000).utc.strftime("%H:%M:%S") : 0 : 0,
            :programe_number=>programe_number.nil? ? "-" : programe_number.split(',').join(" & "),
            :job_description=>job_description.nil? ? "-" : job_description.split(',').join(" & "),
            :utilization=>utilization.nil? || utilization < 0 ? 0 : utilization,
            :total_load_unload_time=>total_load_unload.nil? ? 0 : Time.at(total_load_unload).utc.strftime("%H:%M:%S"),
            :idle_time=>Time.at(idle_time).utc.strftime("%H:%M:%S"),
            :downtime=>Time.at(downtime).utc.strftime("%H:%M:%S"),
            :operator_name=>operator_name.uniq.split(",").join(' & '),
            :operator_id=>operator_id.uniq.split(",").join(' & '),
            :total_run_time=>Time.at(total_run_time).utc.strftime("%H:%M:%S"),
            :targeted_parts=>targeted_parts,
            :operator_efficiency=>operator_efficiency
          }      
       end
   end
end
end

def self.hour_detail(params)
  
  data={}
  machine = Machine.find(params[:machine_id])
  machine_status_report=[];
   date = params[:date].present? && params[:date] !="undefined" ? params[:date] : Date.today.to_s
    s_time = params[:time].split("-")[0]
    e_time = params[:time].split("-")[1]
      start_time = (date+" "+s_time).to_time + 1.second
      end_time = (date+" "+e_time).to_time

   total_hour_data = machine.machine_daily_logs.where("created_at >? AND created_at <?",start_time,end_time).order(:id)
   total_run_chart = total_hour_data.pluck(:total_run_time).uniq.reject{|ff| ff == 0}.count*60
   data_loss_stop_hour =total_hour_data.count != 0 ?  ((total_hour_data[0].created_at - start_time)+(end_time - total_hour_data.last.created_at)) : 0   #for data loss between start_time and end time
   total_idel_chart = 3600 - (total_run_chart+data_loss_stop_hour)
   total_stop_chart = [] 
   hour_split = []
   (start_time.to_i..end_time.to_i).step(600){|pp| hour_split << Time.at(pp).localtime}
   hour_split.map do |minute|
    
    bb=[]
  total_data = machine.machine_daily_logs.where("created_at >? AND created_at <?",minute,minute+10.minutes).order(:id)
  unless total_data.count == 0
      final = []
      frst = total_data[0].machine_status

      total_data.map do |ll|
        if ll.machine_status == frst
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          final << "$$"

          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y/%m/%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
          frst = ll.machine_status
        end
      end
      
      aa = final.split("$$")
      aa.map {|ss| bb << [ss[0],ss[-1]]}
      rr = bb.map{|ll| ll.flatten}
    machine_status_report=[]
      rr.map{|ll| machine_status_report << {:start_time=>ll[0].to_time.strftime("%I:%M:%S %p"),:end_time=>ll[4].to_time.strftime("%I:%M:%S %p"),:status=>ll[1],:time_difference=>Time.at(ll[4].to_time-ll[0].to_time).utc.strftime("%M:%S")}}
        
      total_run_time = total_data.pluck(:total_run_time).uniq.reject{|ll| ll == 0 }.count == 1 ? 0 : (total_data.pluck(:total_run_time).uniq.reject{|ll| ll == 0 }.count*60 - 60)
      total_stop_time = rr.select{|ss| ss[1] == "100"}.map{|ss| ss[4].to_time-ss[0].to_time}.sum if !rr[0].nil?
    data_loss_stop = ((total_data[0].created_at - minute)+(minute+10.minute - total_data.last.created_at))

      total_idle_time = (600 - total_run_time) - (total_stop_time +data_loss_stop)
      total_idle_time = total_idle_time.nil? || total_idle_time < 0 ? 0 : total_idle_time
      total_run_time = total_run_time.nil?  ? 0 : total_run_time > 0 ? total_run_time : 0 
      total_stop_time = total_stop_time.nil? ? 0 : total_stop_time
      total_stop_chart << total_stop_time
      data = {
        :time_interval => minute.localtime.strftime("%I:%M:%S %p")+" - "+(minute+10.minutes).localtime.strftime("%I:%M:%S %p"),
        :run_time=>Time.at(total_run_time).utc.strftime("%H:%M:%S"),
        :ideal_time=>Time.at(total_idle_time).utc.strftime("%H:%M:%S"),
        :stop_time=>Time.at(total_stop_time+data_loss_stop).utc.strftime("%H:%M:%S"),
        :remaining_time_val=>(600-(total_run_time+total_idle_time+total_stop_time)).round() < 0 ? 0 : (600-(total_run_time+total_idle_time+total_stop_time)).round(),
        :total_run_time => Time.at(total_run_chart).utc.strftime("%H:%M:%S"),
        :total_stop_time => Time.at(total_stop_chart.sum).utc.strftime("%H:%M:%S"),
        :total_ideal_time => Time.at((3600-total_run_chart)-(total_stop_chart.sum+data_loss_stop_hour)).utc.strftime("%H:%M:%S"),
        :remaining_time => Time.at(3600-(total_idel_chart+total_run_chart)).utc.strftime("%H:%M:%S")
      }      
 #else

 # false
end
end
end
end
