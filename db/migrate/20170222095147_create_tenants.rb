class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants do |t|
      t.string :tenant_name
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.integer :parent_tenant_id
      t.belongs_to :companytype, foreign_key: true

      t.timestamps
    end
  end
end
