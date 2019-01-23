class CreatePageauthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :pageauthorizations do |t|
      t.string :authorization_name
      t.string :description

      t.timestamps
    end
  end
end
