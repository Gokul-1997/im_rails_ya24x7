class AddShiftNoToShifttransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :shift_no, :integer
  end
end
