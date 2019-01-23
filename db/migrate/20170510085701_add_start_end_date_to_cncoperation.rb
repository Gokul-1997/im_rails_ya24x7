class AddStartEndDateToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :start_date, :date
    add_column :cncoperations, :end_date, :date
    add_column :cncoperations, :cycle_time_dummy, :time
    add_column :cncoperations, :idle_cycle_time_dummy, :time
  end
end
