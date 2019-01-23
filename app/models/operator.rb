class Operator < ApplicationRecord
 #acts_as_paranoid
 acts_as_paranoid
has_many :operator_allocations#,:dependent => :destroy
has_many :reports
has_many :operator_mapping_allocations#,:dependent => :destroy
belongs_to :tenant
has_many :hour_reports
has_many :cnc_hour_reports
has_many :cnc_reports
has_many :ct_reports
has_many :program_reports
end
