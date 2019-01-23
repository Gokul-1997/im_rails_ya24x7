class CreateMachineDailyLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :machine_daily_logs do |t|
      t.integer :parts_count
      t.integer :machine_status
      t.string :job_id
      t.integer :total_run_time
      t.integer :total_cutting_time
      t.integer :run_time
      t.integer :feed_rate
      t.integer :cutting_speed
      t.integer :axis_load
      t.string :axis_name
      t.integer :spindle_speed
      t.integer :spindle_load
      t.integer :total_run_second
      t.string :programe_number
      t.string :programe_description
      t.integer :run_second
      t.references :machine, foreign_key: true

      t.timestamps
    end
  end
end
