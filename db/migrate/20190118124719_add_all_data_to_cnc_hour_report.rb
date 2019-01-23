class AddAllDataToCncHourReport < ActiveRecord::Migration[5.0]
  def change
    add_column :cnc_hour_reports, :feed_rate, :string
    add_column :cnc_hour_reports, :spendle_speed, :string
    add_column :cnc_hour_reports, :oee, :string
    add_column :cnc_hour_reports, :cutting_time, :text
  #  add_column :cnc_reports, :stop_to_start, :text
    add_column :cnc_hour_reports, :spindle_load, :string 
    add_column :cnc_hour_reports, :spindle_m_temp, :string
    add_column :cnc_hour_reports, :servo_load, :text
    add_column :cnc_hour_reports, :servo_m_temp, :text
    add_column :cnc_hour_reports, :puls_code, :text
    add_column :cnc_hour_reports, :test_code, :string
  end
end
