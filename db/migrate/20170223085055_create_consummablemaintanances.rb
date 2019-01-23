class CreateConsummablemaintanances < ActiveRecord::Migration[5.0]
  def change
    create_table :consummablemaintanances do |t|
      t.string :maintance_type
      t.date :change_date
      t.date :next_change_date
      t.string :reason_for_change
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
