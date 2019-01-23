class Cncoperation < ApplicationRecord
acts_as_paranoid
has_many :cncvendors,:dependent => :destroy
has_many :machineallocations,:dependent => :destroy
belongs_to :cncjob
belongs_to :tenant
belongs_to :planstatus
has_many :operatorworkingdetails,:dependent => :destroy
   def self.get_operation(params)
	cncoperation = Cncjob.find(params[:job_id]).cncoperations.order(:operation_no)
   end
end
