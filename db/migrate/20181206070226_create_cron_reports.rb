class CreateCronReports < ActiveRecord::Migration[5.0]
  def change
    create_table :cron_reports do |t|
      t.string :report
      t.string :tenant
      t.string :shift
      t.date :date
      t.string :time

      t.timestamps
    end
  end
end
