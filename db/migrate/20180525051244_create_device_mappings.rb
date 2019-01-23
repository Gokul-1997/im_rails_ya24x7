class CreateDeviceMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :device_mappings do |t|
      t.string :installing_date
      t.string :removing_date
      t.integer :number_of_machine
      t.string :reasons
      t.string :description
      t.string :created_by
      t.string :updated_by
      t.boolean :is_active, default: true
      t.datetime :deleted_at
      t.references :tenant, foreign_key: true
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
