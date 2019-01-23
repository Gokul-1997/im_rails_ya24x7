class AddActualWorkingWithoutBreakToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :actual_working_without_break, :string
  end
end
