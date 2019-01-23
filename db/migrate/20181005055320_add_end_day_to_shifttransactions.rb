class AddEndDayToShifttransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :end_day, :integer
  end
end
