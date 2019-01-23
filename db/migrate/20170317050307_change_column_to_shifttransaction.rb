class ChangeColumnToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    change_table :shifttransactions do |t|
      t.change :shift_start_time,:string
      t.change :shift_end_time,:string
      t.change :actual_working_hours,:string
    end
  end
end
