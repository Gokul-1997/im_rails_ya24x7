class Planstatus < ApplicationRecord
has_many :cncoperations,:dependent => :destroy
belongs_to :machine
end
