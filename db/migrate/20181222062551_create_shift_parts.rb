class CreateShiftParts < ActiveRecord::Migration[5.0]
  def change
    create_table :shift_parts do |t|
      t.date :date
      t.string :time
      t.integer :shift_no
      t.string :part
      t.string :program_number
      t.boolean :is_complete, :default => false
      t.integer :status
      t.string :idle_status
      t.references :machine, foreign_key: true
      t.references :shifttransaction, foreign_key: true

      t.timestamps
    end
  end
end
