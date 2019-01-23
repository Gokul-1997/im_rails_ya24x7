class OperatorMappingAllocationSerializer < ActiveModel::Serializer
  attributes :id,:date,:operator,:operator_allocation,:created_at,:target
  belongs_to :operator
  belongs_to :operator_allocation
end
