class AddIsactiveToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :isactive, :boolean
  end
end
