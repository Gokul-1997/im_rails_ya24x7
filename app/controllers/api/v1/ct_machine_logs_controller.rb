module Api
  module V1
class CtMachineLogsController < ApplicationController
  before_action :set_ct_machine_log, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: %i[create]

  # GET /ct_machine_logs
  def index
    @ct_machine_logs = CtMachineLog.all

    render json: @ct_machine_logs
  end

  # GET /ct_machine_logs/1
  def show
    render json: @ct_machine_log
  end

  # POST /ct_machine_logs
  def ct_machine_logs1
    #byebug
  end


  def create
 #byebug
   puts params[:date]
   params[:date] == "NULL" ? s_date = Time.now : s_date = Time.now#params[:date].to_time
    machine = Machine.find_by_machine_ip(params[:machine_id])
    tenant = machine.tenant
    shift = Shifttransaction.current_shift(tenant.id)
    @data = {"machine_id"=>params[:machine_id],"status"=>params[:status],"from_date"=>s_date,"uptime"=>params[:uptime],"heart_beat"=>params[:heart_beat],:reason=>params[:reason]}
    puts "#{@data}"   
    #date = params[:date]
  date = Date.today.strftime("%Y-%m-%d")
    

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

     case
      when shift.day == 1 && shift.end_day == 1   
        start_time = (date+" "+shift.shift_start_time).to_time
        end_time = (date+" "+shift.shift_end_time).to_time  
      when shift.day == 1 && shift.end_day == 2
        # start_time = (date+" "+shift.shift_start_time).to_time
        # end_time = (date+" "+shift.shift_end_time).to_time+1.day
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



      #byebug
      end_time_for_ideal = Time.now < end_time ? Time.now : end_time
       
       if machine = Machine.find_by_machine_ip(params[:machine_id])
         if machine.ct_machine_logs.last.present?
           machine_data = machine.ct_machine_logs
          
       if (machine_data.last.status == params[:status].to_i) && (machine_data.last.machine_id == machine.id.to_i) && (machine_data.last.reason == params[:reason]) && ( machine_data.where(:status=>params[:status].to_i,machine_id:machine.id.to_i).last.from_date.localtime >= start_time ) && ((s_date.localtime - machine.ct_machine_logs.last.to_date.localtime) <= 5.second )
            machine_log = CtMachineLog.new(:updated_at=>Time.now, :status=>params[:status],:machine_id=>machine.id,:from_date=>machine_data.last.from_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
               
                machine_data.last.update(:updated_at=>Time.now,:to_date=>s_date,:reason=>params[:reason], :status=>params[:status])
              machine.ct_machine_daily_logs.last.update(:updated_at=>Time.now,:to_date=>s_date,:reason=>params[:reason])
       elsif (machine_data.last.status != params[:status].to_i) && (machine_data.last.machine_id == machine.id.to_i) && (machine_data.last.reason == params[:reason]) && ( machine_data.where.not(:status=>params[:status].to_i).where(machine_id:machine.id.to_i).last.from_date.localtime >= start_time ) && ((s_date.localtime - machine.ct_machine_logs.last.to_date.localtime) <= 5.second )
            
             last_machine = CtMachineLog.where(status: machine_data.last.status,machine_id:machine_data.last.machine_id).ids.last
             
            machine_log = CtMachineLog.find(last_machine).update(:updated_at=>Time.now,:to_date=>s_date)
             CtMachineLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
            daily_last_machine = CtMachineDailyLog.where(status: machine.ct_machine_daily_logs.last.status,machine_id:machine.ct_machine_daily_logs.last.machine_id).ids.last
           CtMachineDailyLog.find(daily_last_machine).update(:updated_at=>Time.now,:to_date=>s_date)
           CtMachineDailyLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
       else
       #byebug
      machine_log  = CtMachineLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
        CtMachineDailyLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])                      
       end
     else 
      machine_log = CtMachineLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
        CtMachineDailyLog.create(:status=>params[:status],:machine_id=>machine.id,:from_date=>s_date,:to_date=>s_date,:uptime=>params[:uptime],:heart_beat=>params[:heart_beat],:reason=>params[:reason])
     end
   else
      puts "Not register machine_ip #{params[:machine_id]}"
   end 
   #end
   end

  # PATCH/PUT /ct_machine_logs/1
  def update
    if @ct_machine_log.update(ct_machine_log_params)
      render json: @ct_machine_log
    else
      render json: @ct_machine_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ct_machine_logs/1
  def destroy
    @ct_machine_log.destroy
  end

  def ct_dashboard
    data = CtMachineDailyLog.ct_dashboard(params)
    if data != nil
     running_count1 = []
  ff = {}
  
  data.group_by{|d| d[:unit]}.map do |key2,value2|
     value={}
     value2.group_by{|i| i[:status]}.map do |k,v|
      k = "waste"  if k == nil
      k = "stop"  if k == 100
      k = "running"  if k == 3
      k = "idle"  if k == 0 
      k = "idle1" if k == 1
      value[k] = v.count
     end

     
     ff[key2] = value
  end
render json: {"data" => data.group_by{|d| d[:unit]}, count: ff}

    #render json: data
  end
    #render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ct_machine_log
      @ct_machine_log = CtMachineLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ct_machine_log_params
      params.require(:ct_machine_log).permit(:status, :heart_beat, :from_date, :to_date, :uptime, :reason, :machine_id)
    end
end
end
end
