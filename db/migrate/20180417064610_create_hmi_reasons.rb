class CreateHmiReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :hmi_reasons do |t|
      t.string :name
      t.string :image_path
      t.boolean :is_active

      t.timestamps
    end
  end
end
