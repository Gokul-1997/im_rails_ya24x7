class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.date :start_date
      t.date :delivery_date
      t.integer :quantity
      t.belongs_to :cncjob, foreign_key: true
      t.belongs_to :deliverytype, foreign_key: true

      t.timestamps
    end
  end
end
