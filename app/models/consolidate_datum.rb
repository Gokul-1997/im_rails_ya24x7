class ConsolidateDatum < ApplicationRecord
  belongs_to :machine, -> { with_deleted }

 def self.export_data(params)
  	machine = Machine.find params[:machine_id]
    start_date = params[:start_date].to_date 
    end_date = params[:end_date].to_date
    byebug
    end_date = start_date == end_date ? end_date+1 : end_date
  	machine.consolidate_data.where("created_at >? AND created_at <?",start_date,end_date+1).order(:id)
end
end
