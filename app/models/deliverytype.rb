class Deliverytype < ApplicationRecord
has_many :deliveries,:dependent => :destroy
end
