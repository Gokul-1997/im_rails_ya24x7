class AddColumToMachineLogLast < ActiveRecord::Migration[5.0]
  def change
   add_column :machine_logs, :machine_time, :datetime
   add_column :machine_daily_logs, :machine_time, :datetime
  end
end
