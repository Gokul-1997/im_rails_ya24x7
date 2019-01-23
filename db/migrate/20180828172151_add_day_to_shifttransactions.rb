class AddDayToShifttransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :day, :integer
  end
end
