class Cnctool < ApplicationRecord
  belongs_to :tenant
  belongs_to :machine, -> { with_deleted }
end
