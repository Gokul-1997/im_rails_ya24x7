class CreateShiftTimelineReports < ActiveRecord::Migration[5.0]
  def change
    create_table :shift_timeline_reports do |t|
      t.date :date
      t.integer :ideal_time
      t.integer :run_time
      t.integer :stop_time
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :shifttransaction, foreign_key: true

      t.timestamps
    end
  end
end
