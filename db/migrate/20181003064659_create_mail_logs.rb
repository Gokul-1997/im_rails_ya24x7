class CreateMailLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :mail_logs do |t|
      t.date :date
      t.datetime :stop_time
      t.datetime :start_time
      t.boolean :mail_status
      t.datetime :last_mail_time
      t.string :log_id
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
