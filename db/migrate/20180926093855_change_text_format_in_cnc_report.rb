class ChangeTextFormatInCncReport < ActiveRecord::Migration[5.0]
  def change
   change_column :cnc_reports, :job_description, :text
   change_column :cnc_hour_reports, :job_description, :text
  end
end
