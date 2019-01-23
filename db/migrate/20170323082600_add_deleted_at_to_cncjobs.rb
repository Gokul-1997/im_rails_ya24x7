class AddDeletedAtToCncjobs < ActiveRecord::Migration[5.0]
  def change
    add_column :cncjobs, :deleted_at, :datetime
    add_index :cncjobs, :deleted_at
  end
end
