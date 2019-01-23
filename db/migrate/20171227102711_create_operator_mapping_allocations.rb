class CreateOperatorMappingAllocations < ActiveRecord::Migration[5.0]
  def change
    create_table :operator_mapping_allocations do |t|
      t.date :date
      t.references :operator, foreign_key: true
      t.references :operator_allocation, foreign_key: true

      t.timestamps
    end
  end
end
