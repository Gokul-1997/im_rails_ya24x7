class AddTargetToOperatorMappingAllocations < ActiveRecord::Migration[5.0]
  def change
    add_column :operator_mapping_allocations, :target, :integer, :default => 0
    add_column :operator_mapping_allocations, :pending, :integer, :default => 0
    add_column :operator_mapping_allocations, :rework, :integer, :default => 0
    add_column :operator_mapping_allocations, :approved, :integer, :default => 0
    add_column :operator_mapping_allocations, :rejected, :integer, :default => 0
    add_column :operator_mapping_allocations, :operator_name, :string
    add_column :operator_mapping_allocations, :reason, :string
    add_column :operator_mapping_allocations, :alert, :string
  end
end
