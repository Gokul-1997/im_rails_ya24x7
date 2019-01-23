class CreateDashboards < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboards do |t|
      t.string :machine_name
      t.string :job_name
      t.string :utilization
      t.string :parts_produced
      t.string :downtime
      t.string :machine_status

      t.timestamps
    end
  end
end
