class Consummablemaintanance < ApplicationRecord
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant
end
