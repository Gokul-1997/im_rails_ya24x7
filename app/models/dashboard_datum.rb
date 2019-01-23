class DashboardDatum < ApplicationRecord
  belongs_to :shifttransaction
  belongs_to :tenant
  belongs_to :machine
  serialize :job_wise_part, Array
end
