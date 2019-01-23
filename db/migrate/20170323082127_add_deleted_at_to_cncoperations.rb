class AddDeletedAtToCncoperations < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :deleted_at, :datetime
    add_index :cncoperations, :deleted_at
  end
end
