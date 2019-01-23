class CreateMonthReports < ActiveRecord::Migration[5.0]
  def change
    create_table :month_reports do |t|
      t.date :date
      t.string :file_path
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
