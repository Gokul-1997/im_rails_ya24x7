class CreateMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :materials do |t|
      t.string :suplier_name
      t.string :product_name
      t.date :purchase_date
      t.time :purchase_time
      t.integer :quantity
      t.belongs_to :cncjob, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
