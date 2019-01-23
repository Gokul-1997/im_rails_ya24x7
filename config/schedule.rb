  	# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
 




 # every 60.minutes do
 #   command "/usr/bin/some_great_command"
 #   runner "CncReport.cnc_report",:environment => :development
 #  end

 # every 60.minutes do
 #   command "/usr/bin/some_great_command"
 #   runner "CncHourReport.cnc_hour_report",:environment => :development
 #  end


# every 5.minutes do
#    command "/usr/bin/some_great_command"
#    runner "CncReport.delay_jobs",:environment => :development
#   end

   every 5.minutes do
   #command "/usr/bin/some_great_command"
   runner "CncReport.delay_jobs2",:environment => :development
  end

  # every 20.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "CncReport.cnc_report_speed",:environment => :development
  # end
  # #cnc_hour_report_speed
  
  # every 20.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "CncHourReport.cnc_hour_report_speed",:environment => :development
  # end

  # every 5.minutes do
  #  command "/usr/bin/some_great_command"
  #  runner "Report.test_reports",:environment => :development
  # end

  #  every 5.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "Report.shift_report",:environment => :development
  # end
  #-----------------------------#
  #  every 5.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "Machine.alert_mail",:environment => :development
  # end

  #  every 5.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "Machine.alert_mail1",:environment => :development
  # end

  #alert_mail_exact_time
  
  # every 5.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "Machine.alert_mail_exact_time",:environment => :development
  # end


  # every 5.minutes do
  #  #command "/usr/bin/some_great_command"
  #  runner "Report.hour_report",:environment => :development
  # end

    every 15.minutes do
  #  command "/usr/bin/some_great_command"
    runner "EthernetLog.program_no_report",:environment => :development
   end







 # every 10.minute do
   #command "/usr/bin/some_great_command"
#   runner "MachineDailyLog.data_loss_entry",:environment => :development
#  end
 
  #every 15.minutes do 
  #  runner "MachineDailyLog.consolidate_data",:environment => :development
  #end 

  #every 15.minutes do 
  #  runner "MachineDailyLog.consolidate_data",:environment => :development
  #end

  every :sunday, at: '12pm' do
   command "/usr/bin/cmd"
  rake "log:clear"
  end

  every 1.day, :at => '12:30 am' do
    runner "MachineDailyLog.delete_data",:environment => :development
  end










#  every :month, :at => '12:30 am' do
#    runner "MachineMonthlyLog.data_tranfor",:environment => :development
#  end

#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
