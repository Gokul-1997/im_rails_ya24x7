class AddDummyFieldToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :shift_start_time_dummy, :time
    add_column :shifttransactions, :shift_end_time_dummy, :time
    add_column :shifttransactions, :actual_working_hours_dummy, :time
  end
end
