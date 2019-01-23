class ChangeMachineLogssTable < ActiveRecord::Migration[5.0]
  def change
    add_column :machine_logs, :machine_total_time, :string
    add_column :machine_logs, :cycle_time_per_part, :string
    add_column :machine_daily_logs, :machine_total_time, :string
    add_column :machine_daily_logs, :cycle_time_per_part, :string
  end
end
