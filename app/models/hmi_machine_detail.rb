class HmiMachineDetail < ApplicationRecord
  belongs_to :operator,optional: true
  belongs_to :machine
  belongs_to :tenant
  belongs_to :shifttransaction
end
