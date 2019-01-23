class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :role_name
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
