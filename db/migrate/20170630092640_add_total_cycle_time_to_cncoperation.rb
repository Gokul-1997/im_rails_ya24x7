class AddTotalCycleTimeToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :total_cycle_time, :string
  end
end
