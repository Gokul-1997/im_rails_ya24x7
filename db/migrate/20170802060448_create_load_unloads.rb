class CreateLoadUnloads < ActiveRecord::Migration[5.0]
  def change
    create_table :load_unloads do |t|
      t.integer :load_unload_time
      t.string :program_number
      t.belongs_to :machine, foreign_key: true
      t.timestamps
    end
  end
end
