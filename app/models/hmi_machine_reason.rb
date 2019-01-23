class HmiMachineReason < ApplicationRecord
  belongs_to :hmi_reason
  belongs_to :machine
  belongs_to :tenant
end
