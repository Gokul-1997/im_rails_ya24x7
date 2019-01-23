class CreateOperatorproductiondetails < ActiveRecord::Migration[5.0]
  def change
    create_table :operatorproductiondetails do |t|
      t.integer :no_of_rejects
      t.integer :no_of_parts_produced
      t.integer :parts_moved_to_next_operation
      t.time :total_down_time
      t.string :reason_for_down_time
      t.time :last_machine_reset_time
      t.string :remarks
      t.belongs_to :operatorworkingdetail, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
