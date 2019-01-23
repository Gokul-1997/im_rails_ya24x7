class CreateCnctools < ActiveRecord::Migration[5.0]
  def change
    create_table :cnctools do |t|
      t.string :tool_name
      t.integer :no_of_parts
      t.string :material_string
      t.integer :produced_count
      t.boolean :status
      t.belongs_to :tenant, foreign_key: true
      t.belongs_to :machine, foreign_key: true

      t.timestamps
    end
  end
end
