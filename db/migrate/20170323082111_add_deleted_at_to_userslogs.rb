class AddDeletedAtToUserslogs < ActiveRecord::Migration[5.0]
  def change
    add_column :userslogs, :deleted_at, :datetime
    add_index :userslogs, :deleted_at
  end
end
