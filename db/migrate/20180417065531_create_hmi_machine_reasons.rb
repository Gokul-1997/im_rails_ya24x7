class CreateHmiMachineReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :hmi_machine_reasons do |t|
      t.time :start_time
      t.time :end_time
      t.string :duration
      t.belongs_to :hmi_reason, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true
      t.boolean :is_active

      t.timestamps
    end
  end
end
