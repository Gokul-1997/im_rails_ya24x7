class Menuconfiguration < ApplicationRecord
  belongs_to :page
  belongs_to :role
  belongs_to :pageauthorization
  belongs_to :tenant
end
