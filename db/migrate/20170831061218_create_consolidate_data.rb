class CreateConsolidateData < ActiveRecord::Migration[5.0]
  def change
    create_table :consolidate_data do |t|
      t.integer :parts_count
      t.integer :cons_parts_count
      t.integer :programe_number
      t.integer :machine_status
      t.integer :day
      t.integer :month
      t.integer :year
      t.integer :shift
      t.integer :total_run_time
      t.integer :cons_total_run_time
      t.integer :total_run_second
      t.integer :cons_total_run_second
      t.integer :cutting_time
      t.integer :cons_cutting_time
      t.integer :cycle_time
      t.integer :run_time
      t.integer :cons_run_time
      t.integer :run_second
      t.integer :cons_run_second
      t.integer :cons_down_time
      t.integer :cons_load_unload_time
      t.datetime :log_created_time
      t.integer :total_available_time
      t.belongs_to :machine, foreign_key: true
      t.timestamps
    end
  end
end
