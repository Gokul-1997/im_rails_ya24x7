class CreateAlarms < ActiveRecord::Migration[5.0]
  def change
    create_table :alarms do |t|
      t.integer :alarm_type
      t.integer :alarm_number
      t.string :alarm_message
      t.integer :emergency
      t.belongs_to :machine, foreign_key: true

      t.timestamps
    end
  end
end
