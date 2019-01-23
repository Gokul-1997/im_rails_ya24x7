class CreateCtMachineLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :ct_machine_logs do |t|
      t.integer :status
      t.integer :heart_beat
      t.datetime :from_date
      t.datetime :to_date
      t.datetime :uptime
      t.string :reason
      t.references :machine, foreign_key: true

      t.timestamps
    end
  end
end
