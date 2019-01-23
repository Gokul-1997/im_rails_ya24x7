class DeliveryList < ApplicationRecord
  belongs_to :job_list
  belongs_to :cncclient
end
