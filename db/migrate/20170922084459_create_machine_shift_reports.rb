class CreateMachineShiftReports < ActiveRecord::Migration[5.0]
  def change
    create_table :machine_shift_reports do |t|
      t.date :date
      t.string :shift
      t.string :operator_mfr
      t.string :operator_id
      t.string :machine_name
      t.string :machineid
      t.string :program_number
      t.text :job_description
      t.integer :produced_item
      t.string :load_unload_time
      t.string :ideal_time
      t.string :total_down_time
      t.string :actual_Run_Time
      t.integer :utilization
      t.string :report_type
      t.belongs_to :machine, foreign_key: true

      t.timestamps
    end
  end
end
