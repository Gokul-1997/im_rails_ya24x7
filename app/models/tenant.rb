class Tenant < ApplicationRecord
	acts_as_paranoid
has_many :users
has_many :roles,:dependent => :destroy
has_many :userslogs,:dependent => :destroy
has_many :menuconfigurations,:dependent => :destroy
#has_many :tenantiogs,:dependent => :destroy
has_one :shift,:dependent => :destroy
has_many :cncclients,:dependent => :destroy
has_many :operators,:dependent => :destroy
has_many :cncjobs,:dependent => :destroy
has_many :cncoperation,:dependent => :destroy
has_many :machines,:dependent => :destroy
has_many :materials,:dependent => :destroy
has_many :cncvendors,:dependent => :destroy
has_many :machineallocations,:dependent => :destroy
has_many :cnctools,:dependent => :destroy
has_many :plannedmaintanances,:dependent => :destroy
has_many :mainanceentries,:dependent => :destroy
has_many :consummablemaintanances,:dependent => :destroy
has_many :operatorworkingdetails,:dependent => :destroy
has_many :operatorproductiondetails,:dependent => :destroy
belongs_to :companytype
has_one :problem_status_log
has_many :month_reports
has_many :reports
has_many :operators, :dependent => :destroy
has_many :connection_logs, :dependent => :destroy
has_many :ethernet_logs, :dependent => :destroy
has_many :hour_reports
has_many :program_reports
has_one :setting
has_many :cnc_hour_reports
has_many :cnc_reports
has_many :mail_logs

serialize :machine_type, Array

end
