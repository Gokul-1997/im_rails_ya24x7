class CreateMachineSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :machine_settings do |t|
      t.boolean :is_active, :default => true
      t.string :reason
  #    t.string :time
      t.string :manual
      t.references :machine, foreign_key: true

      t.timestamps
    end
  end
end
