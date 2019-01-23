class RemoveNoOfShiftsFromShifttransaction < ActiveRecord::Migration[5.0]
  def change
remove_column :shifttransactions, :no_of_shifts, :integer
  end
end
