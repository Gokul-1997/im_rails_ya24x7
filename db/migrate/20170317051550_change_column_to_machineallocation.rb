class ChangeColumnToMachineallocation < ActiveRecord::Migration[5.0]
  def change
    change_table :machineallocations do |t|
      t.change :start_time,:string
      t.change :end_time,:string
      t.change :idle_cycle_time,:string
    end
  end
end
