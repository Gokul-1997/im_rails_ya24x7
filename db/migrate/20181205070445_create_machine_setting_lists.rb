class CreateMachineSettingLists < ActiveRecord::Migration[5.0]
  def change
    create_table :machine_setting_lists do |t|
      t.string :setting_name
      t.string :manual
      t.boolean :is_active, :default => false
      t.references :machine_setting, foreign_key: true

      t.timestamps
    end
  end
end
