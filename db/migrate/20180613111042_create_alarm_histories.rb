class CreateAlarmHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :alarm_histories do |t|
      t.string :alarm_type
      t.string :alarm_no
      t.string :axis_no
      t.datetime :time
      t.string :message
      t.integer :alarm_status
      t.references :machine, foreign_key: true

      t.timestamps
    end
  end
end
