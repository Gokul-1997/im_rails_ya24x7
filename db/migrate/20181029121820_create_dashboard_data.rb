class CreateDashboardData < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboard_data do |t|
      t.date :date
      t.string :utilization
      t.string :shift_no
      t.string :machine_status
      t.string :job_id
      t.string :cycle_time
      t.string :run_time
      t.string :idle_time
      t.string :stop_time
      t.text :job_wise_part
      t.references :shifttransaction, foreign_key: true
      t.references :tenant, foreign_key: true
      t.references :machine, foreign_key: true

      t.timestamps
    end
  end
end
