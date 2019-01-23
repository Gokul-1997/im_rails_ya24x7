class AddDeletedAtToShifttransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :shifttransactions, :deleted_at, :datetime
    add_index :shifttransactions, :deleted_at
  end
end
