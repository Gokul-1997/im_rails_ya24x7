class CreateSetAlarmSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :set_alarm_settings do |t|
      t.string :alarm_for
      t.string :time_interval
      t.integer :alarm_type , default:[],array: true
      t.belongs_to :machine, foreign_key: true

      t.timestamps
    end
  end
end
