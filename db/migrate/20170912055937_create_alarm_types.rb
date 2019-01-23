class CreateAlarmTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :alarm_types do |t|
      t.string :alarm_name

      t.timestamps
    end
  end
end
