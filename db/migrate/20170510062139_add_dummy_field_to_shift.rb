class AddDummyFieldToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :working_time_dummy, :time
    add_column :shifts, :day_start_time_dummy, :time
  end
end
