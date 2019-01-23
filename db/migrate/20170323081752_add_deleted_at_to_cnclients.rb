class AddDeletedAtToCnclients < ActiveRecord::Migration[5.0]
  def change
    add_column :cncclients, :deleted_at, :datetime
    add_index :cncclients, :deleted_at
  end
end
