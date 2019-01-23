class Role < ApplicationRecord
has_many :users,:dependent => :destroy
has_many :menuconfigurations,:dependent => :destroy
 belongs_to :tenant,optional:true
end
