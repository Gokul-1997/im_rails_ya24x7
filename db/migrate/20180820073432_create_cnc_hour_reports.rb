class CreateCncHourReports < ActiveRecord::Migration[5.0]
  def change
    create_table :cnc_hour_reports do |t|
      t.datetime :date
      t.string :hour
      t.string :time
      t.integer :shift_no
      t.string :job_description
      t.string :parts_produced
      t.string :run_time
      t.string :ideal_time
      t.string :stop_time
      t.string :time_diff
      t.integer :log_count
      t.integer :utilization
      t.text :all_cycle_time
      t.references :shift, foreign_key: true
      t.references :operator, foreign_key: true
      t.references :machine, foreign_key: true
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
