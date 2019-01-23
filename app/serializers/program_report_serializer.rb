class ProgramReportSerializer < ActiveModel::Serializer
  attributes :id,:date,:shift_no,:time,:operator_id,:operator_name,:machine_name,:machine_type,:program_number,:job_description,:parts_produced,:cycle_time,:loading_and_unloading_time,:idle_time,:total_downtime,:actual_running,:actual_working_hours,:utilization,:shift_id
def machine_name

	object.machine.machine_name
end

def operator_id
	if object.operator_id == nil
	 "Not Assigned" 
    else
      object.operator.operator_spec_id
end
end
def machine_type
	object.machine.machine_type
end
def operator_name
	if object.operator_id == nil
	 "Not Assigned" 
    else
	object.operator.operator_name
end
end

def date
  object.date.strftime("%d-%m-%Y")
end
end
