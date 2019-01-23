class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.date :date
      t.references :shift, foreign_key: true
      t.integer :shift_no
      t.string :time
      t.references :operator, foreign_key: true
      t.references :machine, foreign_key: true
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
      t.references :tenant, foreign_key: true

      t.timestamps
    end
    add_index :reports, :date
    add_index :reports, :shift_no
  end
end
