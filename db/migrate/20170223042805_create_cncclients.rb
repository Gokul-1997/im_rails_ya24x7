class CreateCncclients < ActiveRecord::Migration[5.0]
  def change
    create_table :cncclients do |t|
      t.string :client_name
      t.string :email_id
      t.string :phone_number
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
