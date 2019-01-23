class CreateShifttransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :shifttransactions do |t|
      t.time :shift_start_time
      t.time :shift_end_time
      t.time :actual_working_hours
      t.belongs_to :shift, foreign_key: true

      t.timestamps
    end
  end
end
