class CreatePlants < ActiveRecord::Migration[5.0]
  def change
    create_table :plants do |t|
      t.string :plant_name
      t.string :place
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
