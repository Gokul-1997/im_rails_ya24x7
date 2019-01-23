  #require 'byebug'

class Machine < ApplicationRecord
acts_as_paranoid
has_many :operatorworkingdetails#,:dependent => :destroy
has_many :consummablemaintanances#,:dependent => :destroy
has_many :maintananceentries#,:dependent => :destroy
has_many :plannedmaintanances#,:dependent => :destroy
has_many :machineallocations#,:dependent => :destroy
has_many :machine_logs# ,:dependent => :destroy 
has_many :ct_machine_logs
has_many :ct_machine_daily_logs
has_many :cnctools#,:dependent => :destroy
has_many :consolidate_data# ,:dependent => :destroy 
has_many :data_loss_entries# ,:dependent => :destroy 
belongs_to :tenant
validates :machine_name, presence: true
validates_format_of :device_id,presence: true, with:  /\A[A-Z]{2,5}[-]{1}[Y]{1}[0-9]{3}[-]{1}[0-9]{4}\z/,  message: "Invalid DeviceId"

#validates_format_of :email_id, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i , :allow_blank => true, message: "Invalid Email"

enum unit: {"Unit - 1": 1, "Unit - 2": 2, "Unit - 3": 3, "Unit - 4": 4, "Unit - 5": 5}
has_many :alarms#,:dependent => :destroy
has_many :machine_daily_logs#,:dependent => :destroy
has_many :machine_monthly_logs#,:dependent => :destroy
has_many :pre_monthly_logs#,:dependent => :destroy
has_many :test_machine_logs#,:dependent => :destroy
has_many :operator_allocations#,:dependent => :destroy
has_many :load_unloads
has_many :set_alarm_settings
has_many :ethernet_logs#, :dependent => :destroy
delegate :tenant_name, :to => :tenant, :prefix=> true # law of demeter in bestpractices
has_many :reports
has_many :ct_reports
has_many :hour_reports
has_many :program_reports
has_many :alarm_histories
has_many :alarm_tests
has_many :cnc_hour_reports
has_many :cnc_reports
has_one :planstatus
has_many :dashboard_lives
has_many :dashboard_data
has_one :machine_setting


  # def self.alert_mail # For continues data loss from Raspery Pi
  #   Tenant.where(id: [3,8]).map do |tenant|
  #     ProblemStatusLog.create(tenant_id:tenant.id) unless tenant.problem_status_log.present?
  #    if tenant.machines.present? && MachineLog.where(machine_id:tenant.machines.ids).count != 0
  #      time_dif = Time.now.utc - MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at if MachineLog.where(machine_id:tenant.machines.ids).count != 0
  #      time =  time_dif.nil? ? 0 : time_dif.round()/60
  #       if time > 5 
  #         last_update = MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at.localtime.strftime("%D %I:%M %P")
  #         subject = "Local Alert Data stoppage-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})"
  #         body = "Hi,\nI have not get any data from the below mentioned company from #{last_update}\n#{tenant.tenant_name}"
  #         if tenant.problem_status_log.created_at.present? || (Time.now - tenant.problem_status_log.created_at.localtime)/60 > 240
  #          AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now 
  #          tenant.problem_status_log.update(mail_status:0,created_at:Time.now)
  #        end
  #       else
  #         if tenant.problem_status_log.mail_status == false
  #         subject = "Local Problem Rectified-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})" 
  #         body = "Hi,\nGetting data from the below mentioned company.\n#{tenant.tenant_name}"
  #           last_update = MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at.localtime.strftime("%D %I:%M %P")
  #           AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
  #           tenant.problem_status_log.update(mail_status:1, created_at:nil)
  #         end
  #       end
  #    end
  #   end
  # end

  def self.alert_mail_exact_time # For continues data loss from Raspery Pi
    Tenant.where(id: [1, 3, 8, 10]).map do |tenant|
      ProblemStatusLog.create(tenant_id:tenant.id, mail_status: false) unless tenant.problem_status_log.present?
      if tenant.machines.present? && MachineLog.where(machine_id:tenant.machines.ids).count != 0
        time_dif = Time.now.localtime - MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at.localtime if MachineLog.where(machine_id:tenant.machines.ids).count != 0
        time =  time_dif.nil? ? 0 : time_dif.round()/60
        last_data = MachineLog.where(machine_id:tenant.machines.ids).order(:id).last
        last_update = last_data.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
        date = Date.today.strftime("%Y-%m-%d")
       
        if tenant.problem_status_log.mail_status == false
          if time > 5  
            subject = "Local test Alert Data stoppage-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})"
            body = "Hi,\nI have not get any data from the below mentioned company from #{last_update}\n#{tenant.tenant_name}"
            AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now            
            MailLog.create(date: date, stop_time: last_data.created_at, mail_status: true, log_id: last_data.id, last_mail_time: Time.now, tenant_id: tenant.id)
            tenant.problem_status_log.update(mail_status:1,last_mail_time:Time.now)
          end
        else      
          if tenant.problem_status_log.mail_status == true
            stop_data = tenant.mail_logs.order(:id).last.log_id.to_i
            start_data = MachineLog.where(machine_id: tenant.machines.ids).order(:id).where("id > ?", stop_data).order("id ASC").first
            if start_data.present?
              st_data = start_data.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
              subject = "Local test Problem Rectified-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})"
              body = "Hi,\nGetting data from the below mentioned company #{last_update}.\n#{tenant.tenant_name}"
              AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
              tenant.mail_logs.last.update(start_time: start_data.created_at, mail_status: false, last_mail_time: Time.now)
              tenant.problem_status_log.update(mail_status:0,last_mail_time:nil)
            end
          end
        end
      end
    end
  end


  def self.alert_mail # For continues data loss from Raspery Pi
    Tenant.where(id: [8,1,10]).map do |tenant|
      ProblemStatusLog.create(tenant_id:tenant.id) unless tenant.problem_status_log.present?
      if tenant.machines.present? && MachineLog.where(machine_id:tenant.machines.ids).count != 0
        time_dif = Time.now.utc - MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at if MachineLog.where(machine_id:tenant.machines.ids).count != 0
        time =  time_dif.nil? ? 0 : time_dif.round()/60
        if time > 5
          last_update = MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
          subject = "Local Alert Data stoppage-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})"
          body = "Hi,\nI have not get any data from the below mentioned company from #{last_update}\n#{tenant.tenant_name}"
          if tenant.problem_status_log.last_mail_time.nil? || (Time.now - tenant.problem_status_log.last_mail_time)/60 > 240
            AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
            tenant.problem_status_log.update(mail_status:0,last_mail_time:Time.now)
          end
        else
          if tenant.problem_status_log.mail_status == false
            subject = "Local Problem Rectified-#{tenant.tenant_name.split(" ")[0]}(#{tenant.users[0].phone_number})"
            body = "Hi,\nGetting data from the below mentioned company.\n#{tenant.tenant_name}"
            last_update = MachineLog.where(machine_id:tenant.machines.ids).order(:id).last.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
            #.strftime("%D %I:%M %P")
            AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
            tenant.problem_status_log.update(mail_status:1,last_mail_time:nil)
          end
        end
      end
    end
  end


  def self.alert_mail1 # For continues data loss from Raspery Pi
    Tenant.where(id: [10]).map do |tenant|
      tenant.machines.map do |machine|
        Planstatus.create(machine_id: machine.id) unless machine.planstatus.present?      
        if MachineLog.where(machine_id: machine.id).count != 0
          time_dif = Time.now.utc - MachineLog.where(machine_id:machine.id).order(:id).last.created_at if MachineLog.where(machine_id:machine.id).count != 0
          time =  time_dif.nil? ? 0 : time_dif.round()/60
          if time > 5
            last_update = MachineLog.where(machine_id:machine.id).order(:id).last.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
            subject = "Local Alert Data stoppage-#{tenant.tenant_name.split(" ")[0]}#{machine.machine_name}(#{tenant.users[0].phone_number})"
            body = "Hi,\nI have not get any data from the below mentioned company from #{last_update}\n#{tenant.tenant_name}"
            if machine.planstatus.last_mail_time.nil? || (Time.now - machine.planstatus.last_mail_time)/60 > 240
             AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
             machine.planstatus.update(mail_status:0,last_mail_time:Time.now)
            end
          else
            if machine.planstatus.mail_status == false
              subject = "Local Problem Rectified-#{tenant.tenant_name.split(" ")[0]}#{machine.machine_name}(#{tenant.users[0].phone_number})"
              body = "Hi,\nGetting data from the below mentioned company.\n#{tenant.tenant_name}"
              last_update = MachineLog.where(machine_id:machine.id).order(:id).last.created_at.localtime.strftime("%d/%m/%Y ( %I:%M%p )")
              #.strftime("%D %I:%M %P")
              AlertMailer.send_mail(tenant.id,last_update,subject,body).deliver_now
              machine.planstatus.update(mail_status:1,last_mail_time:nil)
            end
          end
        end
      end
    end
  end


   def self.new_parst_count1(machine_log)

    total_count = []

    #parts = machine_log.where(machine_status: '3').where.not(parts_count: '-9')#.pluck(:parts_count).uniq

    #part_split = machine_log.where(machine_status: 3).pluck(:parts_count).split(0)

    short_value = machine_log.where(machine_status: '3').where.not(parts_count:'-9').pluck(:programe_number, :parts_count).uniq
     if short_value.present?
      short_value.each do |val|

        data = machine_log.find_by(parts_count: val[1], machine_status: '3', programe_number: val[0])
        if machine_log.where(parts_count: data.parts_count, machine_status: '3', programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: '3', programe_number: data.programe_number).last.created_at.to_i
            total_count << val[1]
          end
      end
    end
      return total_count.count
  end

   #-----imtex-------#


 def self.start_cycle_time15(machine_log)
  cycle_start_time = []
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])

        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            if short_value.count == 1
              data2 = short_value[0]
              data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
              #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
              cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
            else
                if index == 0
                  data2 = short_value[0]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at.localtime
                  cycle_start_time << machine_log.where(parts_count: short_value[1][1], programe_number: short_value[1][0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                elsif val == short_value[-1]
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                else
                  data2 = short_value[index+1]
                  cycle_start_time << machine_log.where(parts_count: data2[1], programe_number: data2[0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).first.created_at.localtime
                  #machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0])first.created_at.localtime -
                end
            end
        end
      end
    end
   return cycle_start_time
end


  def self.rs232_cycle_time15(machine_log)

    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq

     if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: "3", programe_number: val[0])
        if machine_log.where(parts_count: data.parts_count, machine_status: "3", programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: "3", programe_number: data.programe_number).last.created_at.to_i
            program_number = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.programe_number
            #cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
            cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number, machine_status: "3").last.created_at.to_i - machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number, machine_status: "3").first.created_at.to_i
            total = {program_number: program_number, cycle_time: cycle_time}
            single_part_cycle_time << total
          end
      end
    end
  return single_part_cycle_time
end



   def self.cycle_time15(machine_log)
    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
    if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last
       # if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
         if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at.to_i
          cycle_abs = []
          if short_value[-1] == val
            cycle_abs << MachineDailyLog.find(data.id).run_time.to_i * 60 + MachineDailyLog.find(data.id).run_second.to_i/1000
            cycle_abs << machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_second.to_i/1000
            if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.present?
              if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.machine_status != [100, 3]
                cycle_abs << machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_second.to_i/1000
              end
            end
            cycle_time =  cycle_abs.max
          else
            cycle_abs << MachineDailyLog.find(data.id).run_time.to_i * 60 + MachineDailyLog.find(data.id).run_second.to_i/1000
            cycle_abs << machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_second.to_i/1000
            if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.present?
              if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.machine_status != [100, 3]
                cycle_abs << machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_second.to_i/1000
              end
            end
            cycle_time =  cycle_abs.max
          end
          total = {program_number: val[0], cycle_time: cycle_time, parts_count: val[1] }
          single_part_cycle_time << total
        end
      end
    end
    return single_part_cycle_time
  end


    def self.run_time15(machine_log)
    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if ll.machine_status == '3'
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
            final << "$$"
          end
        end
      end
      calculate_data = final.split("$$").reject{|i| i.empty? }
      unless calculate_data.empty?
        calculate_data.each do |data|
          if data.count == 1
            if machine_log.first.machine.controller_type == 2
             time << 2
            else
            time << 5
            end
          else
            time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
          end
        end
        return time.sum
      end
      return 0
    end
    return 0
  end



   def self.stop_time15(machine_log)

    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if ll.machine_status == '100'
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
            final << "$$"
          end
        end
      end
      calculate_data = final.split("$$").reject{|i| i.empty? }
      unless calculate_data.empty?
        calculate_data.each do |data|
          time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
        end
        return time.sum
      end
      return 0
    end
    return 0
  end



   def self.ideal_time15(machine_log)
    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if (ll.machine_status != '3') && (ll.machine_status != '100')
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
          final << "$$"
          end
        end
      end

     calculate_data = final.split("$$").reject{|i| i.empty? }
     unless calculate_data.empty?
       calculate_data.each do |data|

        if data.count == 1
            time << 5
          else
            time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
          end
       end
      return time.sum
     end
     return 0
    end
    return 0
  end









  #--------end------------#























def self.parts_count_calculation(machine_log)
  part_count=[]
    #part_split = machine_log.where.not(parts_count:-1).pluck(:parts_count).split("0")
    part_split = machine_log.where(machine_status: 3).pluck(:parts_count).split(0)
    
      part_split.uniq.map do |part|
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
      # parts_count = part_count.sum
      parts_count = part_count.select(&0.method(:<)).sum
 end

def self.calculate_total_run_time(machine_log)
   if !machine_log.where.not(parts_count:"-1").empty?
      total_run=[]
      tot_run = machine_log.where.not(parts_count:"-1").pluck(:total_run_time) 
      tot_run = tot_run.include?(0) ? tot_run.split(0).reject{|i| i.empty?} : tot_run.split(tot_run.min).reject{|i| i.empty?} 
      tot_run.map do |run|  
        total_run << (run[-1] >= run[0] ?  run[-1] - run[0] : run[-1])
      end
      total_run_time = (total_run.sum)*60
   else
      total_run_time = 0
   end 
end

def self.all_cycle_time(machine_log)
  single_part_cycle_time = []
  part_split = machine_log.where.not(parts_count:["-1","100","0"]).pluck(:parts_count).split("0")
  #part_split = machine_log.where(parts_count:'3').pluck(:parts_count).split('0')
  part_split.uniq.map do |parts|
    parts.uniq.map do |part| 
      program_number = machine_log.where(parts_count: part).last.programe_number
      cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
      #cycle_time = Time.at(machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000).utc.strftime("%H:%M:%S")
      total = {program_number: program_number, cycle_time: cycle_time}
      single_part_cycle_time << total
    end
  end
  #a = single_part_cycle_time.group_by{|d| d[:program_number]}
  a = single_part_cycle_time
  return a
end


def self.latest_parts_count_calculation(machine_log)
  
  if machine_log.present?
    total_part = []
    
    collect_data = machine_log.where(machine_status:"3")
    #collect_data = machine_log.where(machine_status:"3")
    if collect_data.present?
      @parts_count = []
      
      collect_data.group_by(&:programe_number).each do |pg_num, count_value|
        part_split = count_value.pluck(:parts_count)
        part = part_split.slice_when { |i| i == -9 }.to_a
        count = []
        part.each do |m|
          if m[-1] == -9 && m[0] != -9
            count << m
          end
        end
        
        if part.count != 1
          if part.last[-1] != -9
            count << part.last
          end
        end


        @parts_count << {programe_number: pg_num, count: count.count}
      end
     total_part << @parts_count
     return total = total_part.flatten.pluck(:count).sum
    else
      return total = 0
    end
  else
    return total = 0
  end
end


def self.latest_parts_count_calculation_hour(machine_log)
  if machine_log.present?
    total_part = []
    collect_data = machine_log.where(machine_status:"3")
    #collect_data = machine_log.where(machine_status:"3")
    if collect_data.present?
      @parts_count = [] 
      collect_data.group_by(&:programe_number).each do |pg_num, count_value|
        part_split = count_value.pluck(:parts_count)
        part = part_split.slice_when { |i| i == -9 }.to_a
        count = []
        part.each do |m|
          if m[-1] == -9
            count << m
          end
        end
        @parts_count << {programe_number: pg_num, count: count.count}
      end
     total_part << @parts_count
     return total = total_part.flatten.pluck(:count).sum
    else
      return total = 0
    end
  else
    return total = 0
  end
end


 def self.dummy_test
  date="2019-01-13"
  tenant = Tenant.find(1)#8#210
  machine = Machine.find(1)#5#85
  shift = Shifttransaction.find(3)#3#67

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
   
 # byebug
   machine_log = machine.machine_daily_logs.where("created_at >= ? AND created_at <= ?",start_time,end_time).order(:id)
   #parts_latest = Machine.parts_count_calculation(machine_log)#.flatten
  
 byebug 
    dataaa = []
    machine_log.each_with_index do |data,index|
     # byebug
      if data == machine_log[-1]
       dataaa << data.created_at.localtime.to_i - data.created_at.localtime.to_i
      else
       # byebug
       dataaa << machine_log[index+1].created_at.localtime.to_i - data.created_at.localtime.to_i
      end
      #byebug
    end
     byebug
   #parts_latest = Machine.latest_parts_count_calculation_hour(machine_log)  
   #all_cycle_time = Machine.all_cycle_time_rabwin(machine_log)
   #run_time = Machine.calculate_total_run_time(machine_log)
   #cycle_time = Machine.cycle_time(machine_log)
   #new_parts = Machine.new_parst_count(machine_log)
   start_cycle_time = Machine.cycle_time_dummy(machine_log)
   byebug
   #old_parts = Machine.start_cycle_time(machine_log)

   
 end




 def self.single_part_report_hour(params)
  #byebug
  #date=Date.today.strftime("%Y-%m-%d")
  #date="2018-06-22"
   date="2018-09-03"
   tenant=Tenant.find(params[:tenant_id])
   machines=params[:machine_id] == "undefined" ? tenant.machines : Machine.where(id:params[:machine_id])
   shift = Shifttransaction.find(params[:shift_id])    

  # date="2018-08-07"
  # tenant = Tenant.find(8)#8#210
  # machine = Machine.where(id: 4)#5#85
  # shift = Shifttransaction.find(3)#3#67

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
   
  
  @alldata = []
  loop_count = 1
  (start_time.to_i..end_time.to_i).step(3600) do |hour|
    
    if hour.to_i != end_time.to_i
    (hour.to_i+3600 < end_time.to_i) ? (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(hour.to_i+3600).strftime("%Y-%m-%d %H:%M")) : (hour_start_time=Time.at(hour).strftime("%Y-%m-%d %H:%M"),hour_end_time=Time.at(end_time).strftime("%Y-%m-%d %H:%M"))
    



    machines.order(:id).map do |mac|

      machine_log1 = mac.machine_daily_logs.where("created_at >= ? AND created_at <= ?",hour_start_time[0].to_time,hour_end_time.to_time).order(:id)
      #parts_count2 = Machine.parts_count_calculation2(machine_log1)#
      duration = hour_end_time.to_time.to_i - hour_start_time[0].to_time.to_i
      #parts_count1 = Machine.parts_count_calculation(machine_log1)#
      #parts_latest = Machine.latest_parts_count_calculation_hour(machine_log1)
      new_parst_count = Machine.new_parst_count(machine_log1)
      start_cycle_time = Machine.start_cycle_time(machine_log1)
      #run_time = Machine.run_time(machine_log1)
      #stop_time = Machine.stop_time(machine_log1)
      #ideal_time = Machine.ideal_time(machine_log1)
      #cycle_time = Machine.cycle_time(machine_log1)

           @data = [
              :time => hour_start_time[0].split(" ")[1]+' - '+hour_end_time.split(" ")[1],
              :duration => duration,
              #:run_time => run_time,
              #:stop_time => stop_time,
              #:ideal_time => ideal_time,
              :date => date,
              :shift_no =>shift.shift_no,
              :machine_name=>mac.machine_name,
              :machine_type=>mac.machine_type,
              :machine_id=>mac.id,
              :part_count => new_parst_count,
              #:cycle_time => cycle_time
              #:part_count=>parts_count1,
              #:parts_count2=>parts_count2,
              #:parts_latest=>parts_latest
            ]
    @alldata << @data
  end
end
end
  return @alldata 
end             

  def self.run_time(machine_log)
    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if ll.machine_status == 3
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
            final << "$$"
          end
        end
      end
      calculate_data = final.split("$$").reject{|i| i.empty? }
      unless calculate_data.empty?
        calculate_data.each do |data|
          if data.count == 1
            time << 5
          else
            time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
          end
        end
        return time.sum
      end
      return 0
    end
    return 0
  end




  def self.stop_time(machine_log)
    
    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if ll.machine_status == 100
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
            final << "$$"
          end
        end
      end
      calculate_data = final.split("$$").reject{|i| i.empty? }
      unless calculate_data.empty?
        calculate_data.each do |data|
          time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
        end
        return time.sum
      end
      return 0
    end
    return 0
  end
 

  def self.ideal_time(machine_log)
    unless machine_log.count == 0
      time = []
      final = []
      machine_log.map do |ll|
        if (ll.machine_status != 3) && (ll.machine_status != 100)
          final << [ll.created_at.in_time_zone("Chennai").strftime("%Y-%m-%d %I:%M:%S %P"),ll.machine_status,ll.total_run_time,ll.total_run_second]
        else
          unless final.last == "$$"
          final << "$$"
          end
        end
      end
     
     calculate_data = final.split("$$").reject{|i| i.empty? }
     unless calculate_data.empty?
       calculate_data.each do |data|
        
        if data.count == 1
            time << 5
          else
            time << data[-1][0].to_time.to_i - data[0][0].to_time.to_i
          end
       end
      return time.sum
     end
     return 0
    end
    return 0
  end

  
  def self.new_parst_count(machine_log)    
    total_count = []    
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq  
    #part_split = machine_log.where(machine_status: 3).pluck(:parts_count).split(0)
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
     if short_value.present? 
      short_value.each do |val|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            total_count << val[1]
          end
      end
    end
    return total_count.count
  end


  def self.cycle_time(machine_log)
    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: '3').where.not(parts_count: '-9').pluck(:programe_number, :parts_count).uniq
     if short_value.present?
      short_value.each_with_index do |val,index|
        data = machine_log.where(parts_count: val[1], programe_number: val[0]).last

        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            program_number = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.programe_number
            cycle_data = machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first
            parts = data.parts_count
            if cycle_data.present?
            if cycle_data.machine_status == 3
              cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
            else
              cycle_time = MachineDailyLog.find(cycle_data.id).run_time * 60 + MachineDailyLog.find(cycle_data.id).run_second.to_i/1000
              if cycle_time < 10
                cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
              end
              #cycle_time = machine_log.where(parts_count: cycle_data.parts_count, programe_number: cycle_data.programe_number).first.run_time * 60 + machine_log.where(parts_count: cycle_data.parts_count, programe_number: cycle_data.programe_number).first.run_second.to_i/1000
            end
          else
            cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
          end
            total = {program_number: program_number, cycle_time: cycle_time, parts_count: parts}
            #byebug
            single_part_cycle_time << total
          end
      end
    end
   
    # single_part_cycle_time.each_with_index do |ll, index|
    #   if ll[:cycle_time] < 10
        
    #   else
        
    #   end
    # end

   return single_part_cycle_time
  end
 

 def self.cycle_time1000(machine_log)
    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
     
     if short_value.present? 
      short_value.each_with_index do |val,index|
        data = machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last  
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            if short_value[-1] == val
              program_number = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.programe_number
              cycle_data = machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first
              cycle_time =  cycle_data.run_time * 60 + cycle_data.run_second.to_i/1000
              #cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
            else
              #data2 = machine_log.find_by(parts_count: short_value[index + 1][1], programe_number: short_value[index + 1][0])   
              program_number = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.programe_number
              cycle_data = machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first
              cycle_time =  cycle_data.run_time * 60 + cycle_data.run_second.to_i/1000
              #cycle_time = machine_log.where(parts_count: data2.parts_count, programe_number: data.programe_number).first.run_time * 60 + machine_log.where(parts_count: data2.parts_count, programe_number: data.programe_number).first.run_second.to_i/1000
            end
            total = {program_number: program_number, cycle_time: cycle_time}
            single_part_cycle_time << total
          end
      end
    end
   return single_part_cycle_time
  end


  def self.cycle_time_dummy(machine_log)
    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
    if short_value.present? 
      short_value.each_with_index do |val,index|
        data = machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last  
        byebug
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
          cycle_abs = []
          if short_value[-1] == val
            cycle_abs << MachineDailyLog.find(data.id).run_time.to_i * 60 + MachineDailyLog.find(data.id).run_second.to_i/1000
            cycle_abs << machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_second.to_i/1000
            if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.present?
              if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.machine_status != [100, 3]
                cycle_abs << machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_second.to_i/1000
              end
            end
            cycle_time =  cycle_abs.max
          else
            cycle_abs << MachineDailyLog.find(data.id).run_time.to_i * 60 + MachineDailyLog.find(data.id).run_second.to_i/1000
            cycle_abs << machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id < ?", data.id).order("id DESC").first.run_second.to_i/1000
            if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.present?
              if machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.machine_status != [100, 3]
                cycle_abs << machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_time.to_i * 60 + machine_log.first.machine.machine_daily_logs.where("id > ?", data.id).order("id ASC").first.run_second.to_i/1000
              end
            end
            cycle_time =  cycle_abs.max
          end  
          total = {program_number: val[0], cycle_time: cycle_time, parts_count: val[1] }
          single_part_cycle_time << total
        end
      end
    end
    return single_part_cycle_time
  end




  def self.cycle_time1(machine_log)
    single_part_cycle_time = []
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
     if short_value.present? 
      short_value.each_with_index do |val,index|
       if short_value[-1] != val
        data = machine_log.find_by(parts_count: short_value[index + 1][1], programe_number: short_value[index + 1][0])
        program_number = machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last.programe_number
        cycle_time = machine_log.where(parts_count: data.parts_count).first.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).first.run_second.to_i/1000
       else
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
        program_number = machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).last.programe_number
        cycle_time = machine_log.where(parts_count: data.parts_count).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
       end
         total = {program_number: program_number, cycle_time: cycle_time}
         single_part_cycle_time << total
      end
    end
   return single_part_cycle_time
  end

  def self.rs232_cycle_time(machine_log)
    
    single_part_cycle_time = []
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq 
     if short_value.present? 
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            program_number = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.programe_number
            #cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_time * 60 + machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.run_second.to_i/1000
            cycle_time = machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at.to_i - machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at.to_i
            total = {program_number: program_number, cycle_time: cycle_time}
            single_part_cycle_time << total
          end
      end
    end
  return single_part_cycle_time    
end


def self.start_cycle_time(machine_log)  
  cycle_start_time = []
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present? 
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
       
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            
            if short_value.count == 1
              data2 = short_value[0]
              data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
              #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
              cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
            
            else
                if index == 0
                  data2 = short_value[0]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at.localtime
                  cycle_start_time << machine_log.where(parts_count: short_value[1][1], programe_number: short_value[1][0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                elsif val == short_value[-1]
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                else
                  data2 = short_value[index+1]
                  cycle_start_time << machine_log.where(parts_count: data2[1], programe_number: data2[0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).first.created_at.localtime
                  #machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0])first.created_at.localtime - 
                end
            end
        end
      end
    end
   return cycle_start_time
end



def self.start_cycle_time12121(machine_log)  
  cycle_start_time = []
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present? 
    byebug
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
       
        if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i  
            
          
            if short_value.count == 1
              abc = []
              data2 = short_value[0]
              
              final = machine_log.where(machine_status: 3, programe_number: data2[0], parts_count: data2[1]).last
              final_s = machine_log.first.machine.machine_daily_logs.where("id < ?", final.id).order("id DESC").first
              
              if machine_log.first.machine.machine_daily_logs.where("id > ?", final.id).order("id ASC").first.present?
               final_a =  machine_log.first.machine.machine_daily_logs.where("id > ?", final.id).order("id ASC").first
              else
                final_a = nil
              end
              
              if final_a.present?
                abc << (final.run_time * 60) + (final.run_second/1000)
                abc << (final_a.run_time * 60) + (final_a.run_second/1000)
                abc << (final_s.run_time * 60) + (final_s.run_second/1000)
              else
                abc << (final.run_time * 60) + (final.run_second/1000)
                abc << (final_a.run_time * 60) + (final_a.run_second/1000)
              end
              cycle_start_time << { program_number: data.programe_number, cycle_time: abc.max, parts_count: data.parts_count }
              #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime  
            else
                if index == 0
                  data2 = short_value[0]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at.localtime
                  cycle_start_time << machine_log.where(parts_count: short_value[1][1], programe_number: short_value[1][0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                elsif val == short_value[-1]
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).first.created_at.localtime
                else
                  data2 = short_value[index+1]
                  cycle_start_time << machine_log.where(parts_count: data2[1], programe_number: data2[0], machine_status: 3).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).first.created_at.localtime
                  #machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0])first.created_at.localtime - 
                end
            end
        end
      end
    end
   return cycle_start_time
end





def self.cycle_time22(machine_log)  
  cycle_start_time = []
  short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
  if short_value.present? 
    short_value.each_with_index do |val,index|
      #sec = short_value[index+1]
      data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])               
      if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
        if short_value.count == 1
          dataaa = machine_log.where(parts_count: val[1], programe_number: val[0])           
          data1 = dataaa.pluck(:run_time)
          data2 = dataaa.pluck(:run_second)
          data = []
          data1.each_with_index do |i,index|
            a = i*60
            b = data2[index]/1000
            c = a + b
            data << c
          end
           value = {program_number: val[0], cycle_time: data.max, parts_count: val[1]}
           cycle_start_time << value
        else
          if val == short_value[-1]
            dataaa = machine_log.where(parts_count: val[1], programe_number: val[0])           
            data1 = dataaa.pluck(:run_time)
            data2 = dataaa.pluck(:run_second)
            data = []
            data1.each_with_index do |i,index|
              a = i*60
              b = data2[index]/1000
              c = a + b
              data << c
            end
             value = {program_number: val[0], cycle_time: data.max, parts_count: val[1]}
             cycle_start_time << value
          else
            sec = short_value[index+1]
            a = machine_log.where(machine_status: 3, programe_number: val[0], parts_count: val[1]).first.created_at
            b = machine_log.where(machine_status: 3, programe_number: sec[0], parts_count: sec[1]).first.created_at - 1.seconds
            dataaa = machine_log.where(created_at: a..b)
            data1 = dataaa.pluck(:run_time)
            data2 = dataaa.pluck(:run_second)
            data = []
            data1.each_with_index do |i,index|
              a = i*60
              b = data2[index]/1000
              c = a + b
              data << c
            end
             value = {program_number: val[0], cycle_time: data.max, parts_count: val[1]}
             cycle_start_time << value
          end
        end
      end
    end
  end
  #byebug
   return cycle_start_time
end

  def self.start_cycle_time111(machine_log)
    cycle_start_time = []
  
    short_value = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:programe_number, :parts_count).uniq
    if short_value.present? 
      short_value.each_with_index do |val,index|
        data = machine_log.find_by(parts_count: val[1], machine_status: 3, programe_number: val[0])
       
        if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at.to_i   
          if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i == data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
            if short_value.count == 1
              data2 = short_value[0]
              data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
              #cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - data.machine.machine_daily_logs.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
              cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number, machine_status: 3).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
            else
                if index == 0                  
                  data2 = short_value[0]
                  timeee = []
                  dataaa = []
                  data1 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0]).id
                  data2 = machine_log.first.machine.machine_daily_logs.where("id < ?", data1).order("id DESC").first.id
                  timeee << data1
                  #timeee << data2
                  timeee.each do |da|
                    a = MachineDailyLog.find(da)
                    if a.parts_count == val[1]
                      timeee << machine_log.first.machine.machine_daily_logs.where("id < ?", a.id).order("id DESC").first.id
                      dataaa << machine_log.first.machine.machine_daily_logs.where("id < ?", a.id).order("id DESC").first.id
                    else
                      @first_rec = MachineDailyLog.where(id: dataaa).where(machine_status: 3).first 
                    end
                  end

                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
                elsif val == short_value[-1]
                  
                  data2 = short_value[-1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).last.created_at.localtime - machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime
                else
                  data2 = short_value[index+1]
                  data3 = machine_log.find_by(parts_count: data2[1], machine_status: 3, programe_number: data2[0])
                  cycle_start_time << machine_log.where(parts_count: data3.parts_count, programe_number: data3.programe_number).first.created_at.localtime - machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0]).first.created_at.localtime
                  #machine_log.where(parts_count: val[1], machine_status: 3, programe_number: val[0])first.created_at.localtime - 
                end
            end
        end
      end
      cycle_start_time << end_time - start_time
      end
    end
   return cycle_start_time
  end






def self.new_parsts_count(machine_log)    
    #parts = machine_log.where(machine_status: 3).where.not(parts_count: -9)#.pluck(:parts_count).uniq  
    #part_split = machine_log.where(machine_status: 3).pluck(:parts_count).split(0)
    total_count = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:parts_count).uniq.count
    return total_count
   end







  
end










#    single_part_cycle_time = []
#    parts = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:parts_count).uniq
#    count = parts
#     if parts.present?
#       data = machine_log.find_by(parts_count: parts[-1], machine_status: 3)
#       if parts.count == 1
#         if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i < data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
#           count = parts.tap(&:pop)
#         else
#           count = parts
#         end
#         if count.present?
#           count.uniq.map do |part|
#             program_number = machine_log.where(parts_count: part).last.programe_number
#             cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
#             total = {program_number: program_number, cycle_time: cycle_time}
#             single_part_cycle_time << total
#           end  
#         end
#       else
#         if machine_log.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i < data.machine.machine_daily_logs.where(parts_count: data.parts_count, machine_status: 3, programe_number: data.programe_number).last.created_at.to_i
#           count = parts.tap(&:pop)
#         else
#           count = parts
#         end

#         if count.present?
#           count.uniq.map do |part|
#             program_number = machine_log.where(parts_count: part).last.programe_number
#             cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
#             total = {program_number: program_number, cycle_time: cycle_time}
#             single_part_cycle_time << total
#           end  
#         end
#       end
#     end
#     return single_part_cycle_time
#   end
# end
# single_part_cycle_time = []
# parts = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:parts_count).uniq
#     count = parts
#     if parts.present?
#       data = machine_log.find_by(parts_count: parts[-1], machine_status: 3)
#       if parts.count == 1
#         if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at == data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at
#           count = parts
          
#            count.uniq.map do |part|
#              program_number = machine_log.where(parts_count: part).last.programe_number
#              cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
#              total = {program_number: program_number, cycle_time: cycle_time}
#              single_part_cycle_time << total
#            end      
#         end
#       else
#       if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at != data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at
#         count = parts.tap(&:pop)
#           count.uniq.map do |part|
#              program_number = machine_log.where(parts_count: part).last.programe_number
#              cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
#              total = {program_number: program_number, cycle_time: cycle_time}
#              single_part_cycle_time << total
#            end  
#       end
#     #end
#     end
#     return single_part_cycle_time
#   end


# return single_part_cycle_time







  # single_part_cycle_time = []
  # parts = machine_log.where(machine_status: 3).where.not(parts_count: -9).pluck(:parts_count).uniq
  #  if parts.present?
  #   datas = machine_log.find_by(parts_count: parts[-1], machine_status:3)
  #     if machine_log.where(parts_count: datas.parts_count, programe_number: datas.programe_number).last.created_at != datas.machine.machine_daily_logs.where(parts_count: datas.parts_count, programe_number: datas.programe_number).last.created_at
  #       parts = parts.tap(&:pop)
  #     end
  #    if parts.present?
     
  #     if parts.count == 1
  #     parts.uniq.map do |part|
  #     data = machine_log.find_by(parts_count: part, machine_status:3)
  #    if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at == data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).last.created_at
  #     program_number = machine_log.where(parts_count: part).last.programe_number
  #     cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
  #     total = {program_number: program_number, cycle_time: cycle_time}
  #     single_part_cycle_time << total
  #     end      
  #   end
  #     else
      
  #   parts.uniq.map do |part|
  #     data = machine_log.find_by(parts_count: part, machine_status:3)
  #    if machine_log.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at == data.machine.machine_daily_logs.where(parts_count: data.parts_count, programe_number: data.programe_number).first.created_at
  #     program_number = machine_log.where(parts_count: part).last.programe_number
  #     cycle_time = machine_log.where(parts_count: part).last.run_time * 60 + machine_log.where(parts_count: part).last.run_second.to_i/1000
  #     total = {program_number: program_number, cycle_time: cycle_time}
  #     single_part_cycle_time << total
  #     end      
  #   end
  # end
  # end
  #   end    
  # a = single_part_cycle_time
  # return a
 #end
# end
     
# end
