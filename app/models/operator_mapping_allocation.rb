class OperatorMappingAllocation < ApplicationRecord
  belongs_to :operator, -> { with_deleted }
  belongs_to :operator_allocation
end
