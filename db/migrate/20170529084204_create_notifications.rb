class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :machine_log, foreign_key: true
      t.string :message
      t.boolean :viewed_status

      t.timestamps
    end
  end
end
