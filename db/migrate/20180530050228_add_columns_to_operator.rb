class AddColumnsToOperator < ActiveRecord::Migration[5.0]
  def change
    add_column :operators, :isactive, :boolean, default: true
    add_column :operators, :deleted_at, :datetime
  end
end
