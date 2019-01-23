class CreateConnectionLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :connection_logs do |t|
      t.datetime :date
      t.string :status
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
