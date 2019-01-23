class AddColumnToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :no_of_shifts, :integer
  end
end
