class Machineallocation < ApplicationRecord
  belongs_to :tenant
  belongs_to :machine, -> { with_deleted }
  belongs_to :cncoperation
end
