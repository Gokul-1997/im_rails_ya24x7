class ChangeColumnToShift < ActiveRecord::Migration[5.0]
  def change
    change_table :shifts do |t|
      t.change :working_time,:string
      t.change :day_start_time,:string
#      t.change :no_of_shifts,:integer
    end
 end
end
