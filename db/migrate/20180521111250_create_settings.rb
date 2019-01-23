class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.boolean :date_wise, default: false
      t.boolean :month_wise, default: false
      t.boolean :shift_wise, default: true
      t.boolean :operator_wise, default: true
      t.boolean :email_notification, default: false
      t.boolean :hour_wise, defalut: false
      t.boolean :program_wise, default: false
      t.boolean :sms, default: false
      t.boolean :notification, default: false
      t.string :created_by
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
