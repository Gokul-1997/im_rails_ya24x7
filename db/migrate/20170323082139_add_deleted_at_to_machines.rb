class AddDeletedAtToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :deleted_at, :datetime
    add_index :machines, :deleted_at
  end
end
