class AddFieldnameToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :machine_logs, :total_cutting_second, :string
    add_column :machine_logs, :x_axis, :string
    add_column :machine_logs, :y_axis, :string
    add_column :machine_logs, :z_axis, :string
    add_column :machine_logs, :reason, :string
    add_column :machine_monthly_logs, :total_cutting_second, :string
    add_column :machine_monthly_logs, :x_axis, :string
    add_column :machine_monthly_logs, :y_axis, :string
    add_column :machine_monthly_logs, :z_axis, :string
    add_column :machine_monthly_logs, :reason, :string
    add_column :machine_daily_logs, :total_cutting_second, :string
    add_column :machine_daily_logs, :x_axis, :string
    add_column :machine_daily_logs, :y_axis, :string
    add_column :machine_daily_logs, :z_axis, :string
    add_column :machine_daily_logs, :reason, :string
  end
end
