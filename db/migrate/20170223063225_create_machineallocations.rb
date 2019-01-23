class CreateMachineallocations < ActiveRecord::Migration[5.0]
  def change
    create_table :machineallocations do |t|
      t.date :from_date
      t.date :to_date
      t.time :start_time
      t.time :end_time
      t.integer :actual_quantity
      t.time :cycle_time
      t.time :idle_cycle_time
      t.decimal :total_down_time
      t.integer :produced_quantiy
      t.belongs_to :tenant, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :cncoperation, foreign_key: true

      t.timestamps
    end
  end
end
