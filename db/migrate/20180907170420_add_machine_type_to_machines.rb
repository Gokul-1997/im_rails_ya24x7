class AddMachineTypeToMachines < ActiveRecord::Migration[5.0]
  def change
   add_column :machines, :controller_type, :integer
  end
end
