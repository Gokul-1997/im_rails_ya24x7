class Cncjob < ApplicationRecord
  acts_as_paranoid
    has_many :cncoperations,:dependent => :destroy
    has_many :materials,:dependent => :destroy
    has_many :machine_logs#,:dependent => :destroy
    has_many :operatorworkingdetails,:dependent => :destroy
    belongs_to :cncclient
    belongs_to :tenant

    def self.get_all_jobs(params)
     #jobs = where(id:MachineLog.where(machine_id:Tenant.find(params[:tenant_id]).machines.ids).where("created_at >= ?",Tenant.find(params[:tenant_id]).shift.day_start_time.to_time).order(:id).map(&:cncjob_id).uniq.compact)
     jobs = Tenant.find(params[:tenant_id]).cncjobs
     return jobs
    end

    def self.job_details(params)
      parts_count =MachineLog.where(cncjob_id:params[:job_id]).last.present? ? MachineLog.where(cncjob_id:params[:job_id]).last.parts_count : 0
      cncjob = Cncjob.find(params[:job_id])
      remaining_parts = cncjob.order_quantity.to_i - parts_count.to_i
      if cncjob.cncoperations.count != 0
        cncjob.cncoperations.map do |job|
         operation_detail = {:operation_name=>job.operation_name}
        end
      else
        operation_detail = nil
      end
      job_details = {:job_start_date=>cncjob.job_start_date,:job_due_date=>cncjob.job_due_date,:order_quantity=>cncjob.order_quantity,:parts_produced=>parts_count,:remaining_parts=>remaining_parts,:parts_deliverd=>0,:rework=>0,:reject=>0,:final_inspected_quantity=>0,:job=>cncjob,:cncclient=>cncjob.cncclient}
    end

      def self.job_page(params)
        operation_parts = []
      job = Cncjob.find(params[:job_id])
      job_operations = job.cncoperations
      operation_numbers = job_operations.pluck(:description) 
      machine_log = MachineLog.where(last_machine_on:operation_numbers)
             
      operation_numbers.map do |no|

        if machine_log.where(last_machine_on:no).where.not(parts_count:"-1").order(:id).last.present?
       operation_parts << machine_log.where(last_machine_on:no).where.not(parts_count:"-1").order(:id).last.parts_count.to_i 
       else
        operation_parts << 0
       end
     end
      #operation_data = operation_numbers.map{|pp| {:operation_parts_produced=>machine_log.where(last_machine_on:pp).where.not(parts_count:"-1").order(:id).last.parts_count,:order_quantity=>order_quantity}}
      parts_produced = operation_parts.empty? ?  0 : operation_parts.min
      parts_remaining = job.order_quantity - parts_produced
       data = {
        :job_detail=>job,
        :parts_produced=>parts_produced,
        :parts_remaining=>parts_remaining,
        :parts_deliverd=>0,
        :parts_reject=>0,
        :parts_rework=>0,
        :fiq=>0
       }
       return data
    end

   def self.job_page_operation(params)
      job = Cncjob.find(params[:job_id])
      operation_numbers = job.cncoperations
       operation_numbers.map do |no|
        parts_produced = MachineLog.where(last_machine_on:no.description).where.not(parts_count:"-1").last.present? ? MachineLog.where(last_machine_on:no.description).where.not(parts_count:"-1").last.parts_count.to_i : 0
      operation_data = {
      :operation_name => no.description,
      :total_parts => job.order_quantity,
      :parts_produced => parts_produced,
      :parts_remaining => job.order_quantity.to_i - parts_produced
      }      
    end
   end

        def self.operation_detail(params)
      job = Cncjob.find(params[:job_id])
      start_time = job.tenant.shift.day_start_time.to_time - 2.day
      order_quantity = job.order_quantity
      operation_detail = job.cncoperations
      operation_detail.map do |ll|
          parts_produced = MachineLog.where(last_machine_on:ll.description).last.present? ? MachineLog.where(last_machine_on:ll.description).last.parts_count : 0
        operation_detail = {
          :description=>ll.description,
          :operation_no=>ll.operation_no,
          :parts_produced=>parts_produced,
          :remaining_parts=>order_quantity.to_i - parts_produced.to_i,
          :reject=> ll.operatorworkingdetails.where(:created_at=>start_time..Time.now).pluck(:no_of_rejects).map(&:to_i).sum,
          :rework=>ll.operatorworkingdetails.where(:created_at=>start_time..Time.now).pluck(:no_of_reworks).map(&:to_i).sum,
          :inspected=>0,
          :operation_name=>ll.operation_name,
          :cycle_time=>ll.cycle_time,
          :idle_cycle_time=>ll.idle_cycle_time,
          :start_date=>ll.start_date,
          :end_date=>ll.end_date
      }
      end
   end
end
