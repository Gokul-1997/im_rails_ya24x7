class AddCycleTime < ActiveRecord::Migration[5.0]
  def change
  
  add_column :machine_logs, :cycle_time_minutes, :string
  add_column :machine_daily_logs, :cycle_time_minutes, :string
  
  end
end
