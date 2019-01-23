class CreateTenantSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :tenant_settings do |t|
      t.boolean :is_active, :default => true
      t.string :reason
      t.string :manual
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
