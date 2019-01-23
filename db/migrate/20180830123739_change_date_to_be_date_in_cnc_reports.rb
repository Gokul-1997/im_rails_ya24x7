class ChangeDateToBeDateInCncReports < ActiveRecord::Migration[5.0]
  def change
  change_column :cnc_hour_reports, :date, :date
  change_column :cnc_reports, :date, :date  
end
end
