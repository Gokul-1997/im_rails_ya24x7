class CreateCtReports < ActiveRecord::Migration[5.0]
  def change
    create_table :ct_reports do |t|
      t.date :date
      t.string :shift_no
      t.string :time
      t.string :run_time
      t.string :idle_time
      t.string :stop_time
      t.string :total_time
      t.string :actual_shifttime
      t.string :utilization
      t.references :operator, foreign_key: true
      t.references :machine, foreign_key: true
      t.references :shift, foreign_key: true
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
