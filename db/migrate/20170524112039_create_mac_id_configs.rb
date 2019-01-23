class CreateMacIdConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :mac_id_configs do |t|
      t.string :mac_id
      t.string :player_id

      t.timestamps
    end
  end
end
