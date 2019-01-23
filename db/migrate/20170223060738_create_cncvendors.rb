class CreateCncvendors < ActiveRecord::Migration[5.0]
  def change
    create_table :cncvendors do |t|
      t.string :vendor_name
      t.date :start_date
      t.date :delivery_date
      t.integer :quantity
      t.string :phone_number
      t.string :email_id
      t.belongs_to :cncoperation, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
