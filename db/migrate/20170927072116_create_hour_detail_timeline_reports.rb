class CreateHourDetailTimelineReports < ActiveRecord::Migration[5.0]
  def change
    create_table :hour_detail_timeline_reports do |t|
      t.string :start_time
      t.string :end_time
      t.integer :ideal_time
      t.integer :run_time
      t.integer :stop_time
      t.belongs_to :hour_timeline_report, foreign_key: true

      t.timestamps
    end
  end
end
