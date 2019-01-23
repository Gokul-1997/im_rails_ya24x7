class CreateHourReports < ActiveRecord::Migration[5.0]
  def change
    create_table :hour_reports do |t|
      t.date :date
      t.string :hour
      t.belongs_to :shift, foreign_key: true
      t.integer :shift_no
      t.string :time
      t.belongs_to :operator, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.string :program_number
      t.string :job_description
      t.integer :parts_produced
      t.string :cycle_time
      t.string :loading_and_unloading_time
      t.string :idle_time
      t.string :total_downtime
      t.string :actual_running
      t.string :actual_working_hours
      t.string :utilization
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
