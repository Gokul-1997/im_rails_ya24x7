class CreateCommonSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :common_settings do |t|
      t.string :setting_name
      t.integer :setting_id

      t.timestamps
    end
  end
end
