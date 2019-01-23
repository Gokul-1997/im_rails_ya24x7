class CreateErrorMasters < ActiveRecord::Migration[5.0]
  def change
    create_table :error_masters do |t|
      t.string :error_code
      t.string :message
      t.string :description

      t.timestamps
    end
  end
end
