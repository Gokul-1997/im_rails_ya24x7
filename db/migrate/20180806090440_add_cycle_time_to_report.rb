class AddCycleTimeToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :all_cycle_time, :text, array:true
  end
end
