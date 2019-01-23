class CreateOeeCalculations < ActiveRecord::Migration[5.0]
  def change
    create_table :oee_calculations do |t|
      t.string :duration
      t.string :break_time
      t.string :balance
      t.date :date
      t.string :prod_time
      t.text :prog_count
      t.references :machine, foreign_key: true
      t.references :shifttransaction, foreign_key: true

      t.timestamps
    end
  end
end
