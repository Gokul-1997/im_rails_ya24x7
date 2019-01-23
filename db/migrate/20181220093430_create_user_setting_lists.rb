class CreateUserSettingLists < ActiveRecord::Migration[5.0]
  def change
    create_table :user_setting_lists do |t|
      t.string :setting_name
      t.string :manual
      t.boolean :is_active, :default => false
      t.references :user_setting, foreign_key: true

      t.timestamps
    end
  end
end
