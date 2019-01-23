class AddFieldnameToCncReport < ActiveRecord::Migration[5.0]
  def change
  	add_column :cnc_reports, :data_part, :integer
  	add_column :cnc_reports, :target, :integer
  	add_column :cnc_reports, :approved, :integer
  	add_column :cnc_reports, :rework, :integer
  	add_column :cnc_reports, :reject, :integer
  	add_column :cnc_reports, :feed_rate, :string
  	add_column :cnc_reports, :spendle_speed, :string
  	add_column :cnc_reports, :oee, :string
  	add_column :cnc_reports, :cutting_time, :text
  	add_column :cnc_reports, :stop_to_start, :text
  end
end
