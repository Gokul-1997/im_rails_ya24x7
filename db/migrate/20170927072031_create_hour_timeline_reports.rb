class CreateHourTimelineReports < ActiveRecord::Migration[5.0]
  def change
    create_table :hour_timeline_reports do |t|
      t.string :start_time
      t.string :end_time
      t.integer :ideal_time
      t.integer :run_time
      t.integer :stop_time
      t.belongs_to :shift_timeline_report, foreign_key: true

      t.timestamps
    end
  end
end
