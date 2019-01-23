class AddDeletedAtToAlarms < ActiveRecord::Migration[5.0]
  def change
    add_column :alarms, :deleted_at, :datetime
    add_index :alarms, :deleted_at
  end
end
