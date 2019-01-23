class CreateCncjobs < ActiveRecord::Migration[5.0]
  def change
    create_table :cncjobs do |t|
      t.string :description
      t.date :job_start_date
      t.date :job_due_date
      t.integer :order_quantity
      t.belongs_to :cncclient, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
