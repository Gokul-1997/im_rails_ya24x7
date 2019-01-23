class DashboardSerializer < ActiveModel::Serializer
  attributes :id,:machine_name,:job_name,:utilization,:parts_produced,:downtime,:machine_status
end
