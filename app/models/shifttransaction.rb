class Shifttransaction < ApplicationRecord
  acts_as_paranoid
  has_many :operatorworkingdetails,:dependent => :destroy
  has_many :break_times,:dependent => :destroy
  has_many :operator_allocations,:dependent => :destroy
  belongs_to :shift

 def self.get_all_shift(params)
  	tenant = Tenant.find(params[:tenant_id])
  	shift = tenant.shift.shifttransactions.select{|ll| ll.shift_start_time.to_time.in_time_zone("Chennai") < Time.now && ll.shift_end_time.to_time.in_time_zone("Chennai") > Time.now}
  	return shift
  end


def self.find_shift(params)
  tenant_id = params[:tenant_id]
  shift = Shifttransaction.current_shift(tenant_id)
end

def self.current_shift(tenant_id)
  shift = []
  tenant = Tenant.find(tenant_id)
  if tenant.shift.shifttransactions != []
    tenant.shift.shifttransactions.map do |ll|
      if tenant.id != 8
        if ll.shift_start_time.include?("PM") && ll.shift_end_time.include?("AM")
          if Time.now.strftime("%p") == "AM"
            if ll.shift_start_time.to_time < Time.now + 1.day  && ll.shift_end_time.to_time > Time.now
              shift = ll
            end 
          else
            if ll.shift_start_time.to_time < Time.now && ll.shift_end_time.to_time + 1.day > Time.now
              shift = ll
            end 
          end
        else
          if  ll.shift_start_time.to_time < Time.now && ll.shift_end_time.to_time > Time.now
            shift = ll
          end
        end
      else
        case
          when ll.day == 1 && ll.end_day == 1
            duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time
            if duration.include?(Time.now)
              shift = ll
            end
          when ll.day == 1 && ll.end_day == 2
            if Time.now.strftime("%p") == "AM"
              duration = ll.shift_start_time.to_time-1.day..ll.shift_end_time.to_time
             else
              duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time+1.day
             end

            #duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time+1.day
            if duration.include?(Time.now)
              shift = ll
            end     
          else
            duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time
            if duration.include?(Time.now)
              shift = ll
            end     
          end
      end
    end
      return shift
  end
end




 # else
    # if tenant.shift.shifttransactions != []
    #   tenant.shift.shifttransactions.map do |ll|
    #     if ll.day == 1 && ll.end_day == 1
    #       duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time
    #       if duration.include?(Time.now)
    #         shift = ll
    #       end
    #     elsif ll.day == 1 && ll.end_day == 2
    #       duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time+1.day
    #       if duration.include?(Time.now)
    #         shift = ll
    #       end
    #     else
    #       duration = ll.shift_start_time.to_time+1.day..ll.shift_end_time.to_time+1.day
    #       if duration.include?(Time.now)
    #         shift = ll
    #       end
    #     end
    #   end
    # end
  #end
#end








def self.current_shift1#(31)
  shift = []
  #a_time = (Date.today.beginning_of_day.to_time + 1.day + 5.minutes).utc
  #byebug
  tenant = Tenant.find(8)
  if tenant.shift.present?    
    if tenant.shift.shifttransactions.present?
    
    tenant.shift.shifttransactions.map do |ll|
      
      # if ll.shift_start_time.include?("PM") && ll.shift_end_time.include?("AM")
      #   if Time.now.strftime("%p") == "AM"
      #     if ll.shift_start_time.to_time < Time.now + 1.day  && ll.shift_end_time.to_time > Time.now
      #       shift = ll
      #     end 
      #   else
      #     if ll.shift_start_time.to_time < Time.now && ll.shift_end_time.to_time + 1.day > Time.now
      #       shift = ll
      #     end 
      #   end
      # else
      #   if ll.shift_start_time.to_time < Time.now && ll.shift_end_time.to_time > Time.now
      #     shift = ll
      #   end
      # end
      case
          when ll.day == 1 && ll.end_day == 1
            duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time
            if duration.include?(a_time)
              shift = ll
            end
          when ll.day == 1 && ll.end_day == 2

            duration = ll.shift_start_time.to_time..ll.shift_end_time.to_time+1.day
            if duration.include?(a_time)
              shift = ll
            end     
          else
            duration = ll.shift_start_time.to_time+1.day..ll.shift_end_time.to_time+1.day
            if duration.include?(a_time)
              shift = ll
            end     
          end

      end
       return shift
    else
      return "No Shifttransactions at Time"
    end
  else
    return "No Shift"
  end
end









end
