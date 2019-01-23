class CreateCncoperations < ActiveRecord::Migration[5.0]
  def change
    create_table :cncoperations do |t|
      t.string :operation_name
      t.string :description
      t.string :plan_status
      t.belongs_to :cncjob, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
