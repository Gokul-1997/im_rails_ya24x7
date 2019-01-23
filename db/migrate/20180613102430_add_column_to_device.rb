class AddColumnToDevice < ActiveRecord::Migration[5.0]
  def change
   add_reference :devices, :device_type, foreign_key: true
   add_column :devices, :updated_by, :string
  end
end
