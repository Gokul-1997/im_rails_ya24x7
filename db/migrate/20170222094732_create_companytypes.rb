class CreateCompanytypes < ActiveRecord::Migration[5.0]
  def change
    create_table :companytypes do |t|
      t.string :companytype_name
      t.string :description

      t.timestamps
    end
  end
end
