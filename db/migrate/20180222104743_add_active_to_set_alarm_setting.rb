class AddActiveToSetAlarmSetting < ActiveRecord::Migration[5.0]
  def change
     add_column :set_alarm_settings, :active, :boolean
  end
end
