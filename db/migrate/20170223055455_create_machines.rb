class CreateMachines < ActiveRecord::Migration[5.0]
  def change
    create_table :machines do |t|
      t.string :machine_name
      t.string :machine_model
      t.string :machine_serial_no
      t.string :machine_type
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
