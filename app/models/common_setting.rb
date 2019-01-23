class CommonSetting < ApplicationRecord
  enum type: {"Tenant-Setting": 1, "User-Setting": 2, "Machine-Setting": 3}
  enum machine_type: {"Ethernet": 1, "Rs232": 2, "Ct/Pt": 3}
end
