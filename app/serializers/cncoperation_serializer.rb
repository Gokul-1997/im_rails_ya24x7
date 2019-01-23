class CncoperationSerializer < ActiveModel::Serializer
  attributes :id,:operation_name,:description,:cncjob_id,:tenant_id,:planstatus_id,:cycle_time,:idle_cycle_time,:start_date,:end_date,:cycle_time_dummy,:idle_cycle_time_dummy,:operation_no,:total_cycle_time	
end
