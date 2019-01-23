class AddDeletedAtToOperatorworkingdetails < ActiveRecord::Migration[5.0]
  def change
  	remove_column :operatorworkingdetails, :deleted_at, :string
    add_column :operatorworkingdetails, :deleted_at, :datetime
#    add_index :operatorworkingdetails, :deleted_at
  end
end
