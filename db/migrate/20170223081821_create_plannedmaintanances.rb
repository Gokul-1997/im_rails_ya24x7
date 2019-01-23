class CreatePlannedmaintanances < ActiveRecord::Migration[5.0]
  def change
    create_table :plannedmaintanances do |t|
      t.string :maintanance_type
      t.date :duration_from
      t.date :duration_to
      t.date :expire_date
      t.string :supplier_name
      t.string :remarks
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
