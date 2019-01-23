class CreateUserslogs < ActiveRecord::Migration[5.0]
  def change
    create_table :userslogs do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_id
      t.string :password
      t.string :phone_number
      t.string :remarks
      t.belongs_to :usertype, foreign_key: true
      t.belongs_to :approval, foreign_key: true
      t.belongs_to :tenant, foreign_key: true
      t.belongs_to :role, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
