class EthernetLog < ApplicationRecord
  belongs_to :machine, -> { with_deleted }

   def self.program_no_report

   time_now = Time.now
   tenant_active=Tenant.where(isactive:true).ids
        date=Date.today.strftime("%Y-%m-%d")
        #data=[]
        tenant_active.map do |tenant_i|
         tenant=Tenant.find(tenant_i)
         machines= tenant.machines.where(controller_type: 1)
   #shifts = tenant.shift.shifttransactions
#shifts.map do |shift|
         shiftstarttime=tenant.shift.day_start_time
         shift = Shifttransaction.current_shift(tenant.id)
             if shift != []





           #  if shift.shift_start_time.include?("PM") && shift.shift_end_time.include?("AM")
           #         if Time.now.strftime("%p") == "AM"
           #           date = (Date.today - 1).strftime("%Y-%m-%d")
           #         end
           #          start_time = (date+" "+shift.shift_start_time).to_time
           #          end_time = (date+" "+shift.shift_end_time).to_time+1.day
           #   elsif shift.shift_start_time.include?("AM") && shift.shift_end_time.include?("AM")
           #     if Time.now.strftime("%p") == "AM"
           #           date = (Date.today - 1).strftime("%Y-%m-%d")
           #         end
           #          start_time = (date+" "+shift.shift_start_time).to_time+1.day
           #          end_time = (date+" "+shift.shift_end_time).to_time+1.day
           #   else
           #         start_time = (date+" "+shift.shift_start_time).to_time
           #         end_time = (date+" "+shift.shift_end_time).to_time
           #   end


                 if tenant.id != 213 || tenant.id != 218
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
              total_shift_time_available_for_downtime =  time_now - start_time
            machines.order(:id).map do |mac|
              machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)

              program_numbers = machine_log1.pluck(:programe_number).uniq.reject{|i| i == "0" || i == ""}

              if program_numbers != []


                      program_numbers.map do | program|

              machine_log = machine_log1.where(:programe_number=>program)


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

                 # operator_id = shift.operator_allocations.where(machine_id:mac.id).last.nil? ?  nil : shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.present? ? shift.operator_allocations.where(machine_id:mac.id).last.operator_mapping_allocations.where(:date=>date.to_date).last.operator.id : nil
                  # for operator allocation
                    if shift.operator_allocations.where(machine_id:mac.id).last.nil?
                      operator_id = nil
                    else
                      if shift.operator_allocations.where(machine_id:mac.id).present?


                   #    if shift.operator_allocations.where(machine_id:mac.id).present?
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
###############

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

         ProgramReport.create!(date:data[0][:date], shift_no: data[0][:shift_no], time: data[0][:time], operator_id: data[0][:operator_id], machine_id: data[0][:machine_id], program_number: data[0][:program_number], job_description: data[0][:job_description], parts_produced: data[0][:parts_produced], cycle_time: data[0][:cycle_time], loading_and_unloading_time: data[0][:loading_and_unloading_time], idle_time: data[0][:idle_time], total_downtime: data[0][:total_downtime], actual_running: data[0][:actual_running], actual_working_hours: data[0][:actual_working_hours], tenant_id: data[0][:tenant_id],utilization:data[0][:utilization],shift_id: data[0][:shift_id])
                      end
               end
            end
          end
      #end
         end
        end

  end









end
