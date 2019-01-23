class AddMachineIdToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :machine_ip, :string
  end
end
