class AddCycleTimeToLoadUnload < ActiveRecord::Migration[5.0]
  def change
    add_column :load_unloads, :cycle_time, :string
  end
end
