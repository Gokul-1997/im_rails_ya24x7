class Cncclient < ApplicationRecord
	acts_as_paranoid
  has_many :cncjobs,:dependent => :destroy
  has_many :job_lists,:dependent => :destroy
  has_many :delivery_lists,:dependent => :destroy
  belongs_to :tenant
end
