class CreateUserSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_settings do |t|
      t.boolean :is_active, :default => true
      t.string :reason
      t.string :manual
      t.text :machine
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
