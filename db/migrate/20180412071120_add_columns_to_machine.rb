class AddColumnsToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :unit, :integer
    add_column :machines, :device_id, :string
  end
end
