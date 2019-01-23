class Approval < ApplicationRecord
has_many :users#,:dependent => :destroy
end
