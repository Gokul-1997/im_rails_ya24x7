class CreateDeliverytypes < ActiveRecord::Migration[5.0]
  def change
    create_table :deliverytypes do |t|
      t.string :deliverytype_name
      t.string :description

      t.timestamps
    end
  end
end
