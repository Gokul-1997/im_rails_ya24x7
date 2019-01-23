class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :device_name
      t.string :description
      t.string :purchase_date
      t.string :created_by
      t.boolean :is_active, default: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
