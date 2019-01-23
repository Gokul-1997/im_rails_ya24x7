class AddCyclyeTimeToCnclob < ActiveRecord::Migration[5.0]
  def change
    add_column :cncjobs, :cycle_time, :string
    add_column :cncjobs, :idle_cycle_time, :string
  end
end
