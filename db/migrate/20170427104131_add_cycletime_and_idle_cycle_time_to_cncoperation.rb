class AddCycletimeAndIdleCycleTimeToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :cycle_time, :string
    add_column :cncoperations, :idle_cycle_time, :string
  end
end
