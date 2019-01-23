class CtReport < ApplicationRecord
  belongs_to :operator, :optional=>true
  belongs_to :machine
  belongs_to :shift
  belongs_to :tenant
end
