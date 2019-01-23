class CreateBreakTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :break_times do |t|
      t.string :reasion
      t.string :start_time
      t.string :end_time
      t.string :total_minutes
      t.belongs_to :shifttransaction, foreign_key: true

      t.timestamps
    end
  end
end
