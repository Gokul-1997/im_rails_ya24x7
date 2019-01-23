class Delivery < ApplicationRecord
belongs_to :tenant 
 belongs_to :cncjob
  belongs_to :deliverytype
end
