class CreateOperatorAllocations < ActiveRecord::Migration[5.0]
  def change
    create_table :operator_allocations do |t|
      t.belongs_to :operator, foreign_key: true
      t.belongs_to :shifttransaction, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
