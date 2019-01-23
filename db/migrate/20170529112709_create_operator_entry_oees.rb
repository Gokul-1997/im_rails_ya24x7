class CreateOperatorEntryOees < ActiveRecord::Migration[5.0]
  def change
    create_table :operator_entry_oees do |t|
      t.string :total_part
      t.string :idle_run_rate
      t.string :reject_part
      t.belongs_to :cncoperation, foreign_key: true
      t.belongs_to :shifttransaction, foreign_key: true
      t.belongs_to :machine, foreign_key: true

      t.timestamps
    end
  end
end
