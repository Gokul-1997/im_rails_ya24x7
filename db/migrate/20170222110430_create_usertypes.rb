class CreateUsertypes < ActiveRecord::Migration[5.0]
  def change
    create_table :usertypes do |t|
      t.string :usertype_name
      t.string :description

      t.timestamps
    end
  end
end
