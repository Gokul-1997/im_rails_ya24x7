class AddTenantIdToOperatorAllocation < ActiveRecord::Migration[5.0]
  def change
    add_reference :operator_allocations, :tenant, foreign_key: true
  end
end
