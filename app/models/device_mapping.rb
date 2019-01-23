class DeviceMapping < ApplicationRecord
  belongs_to :tenant
  belongs_to :device, -> { with_deleted }
end
