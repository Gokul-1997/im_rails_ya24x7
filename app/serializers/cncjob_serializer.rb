class CncjobSerializer < ActiveModel::Serializer
  attributes :id,:description,:job_start_date,:job_due_date,:order_quantity,:job_id,:cncclient_id
  
end
