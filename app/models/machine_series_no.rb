class MachineSeriesNo < ApplicationRecord
 has_and_belongs_to_many :alarm_codes
end
