class AddIsactiveToTenant < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :isactive, :boolean
  end
end
