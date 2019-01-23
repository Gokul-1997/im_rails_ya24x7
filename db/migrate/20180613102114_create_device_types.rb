class CreateDeviceTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :device_types do |t|
      t.string :name
      t.integer :count
      t.decimal :per_pic_price
      t.decimal :total_price
      t.datetime :purchase_date
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
