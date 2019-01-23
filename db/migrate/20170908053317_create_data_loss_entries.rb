class CreateDataLossEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :data_loss_entries do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :downtime
      t.string :parts_produced
      t.integer :total_second
      t.integer :program_no
      t.integer :run_time
      t.boolean :entry_status
      t.belongs_to :machine, foreign_key: true
      t.timestamps
    end
  end
end
