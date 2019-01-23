class AddCategoryToAlarms < ActiveRecord::Migration[5.0]
  def change 
   add_column :tenants, :machine_type, :text
  end
end
