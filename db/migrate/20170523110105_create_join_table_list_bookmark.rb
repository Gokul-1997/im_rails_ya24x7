class CreateJoinTableListBookmark < ActiveRecord::Migration[5.0]
  def change
    create_join_table :MachineSeriesNos, :AlarmCodes do |t|
      # t.index [:machine_series_no_id, :alarm_code_id]
      # t.index [:alarm_code_id, :machine_series_no_id]
    end
  end
end
