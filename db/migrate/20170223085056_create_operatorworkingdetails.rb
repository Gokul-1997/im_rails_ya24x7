class CreateOperatorworkingdetails < ActiveRecord::Migration[5.0]
  def change
    create_table :operatorworkingdetails do |t|
      t.date :working_date
      t.string :from_time
      t.string :to_time
      t.belongs_to :user, foreign_key: true
      t.belongs_to :shifttransaction, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true
      t.string :deleted_at
      t.string :no_of_rejects
      t.string :no_of_parts_produced
      t.string :parts_moved_to_next_operation
      t.string :total_down_time
      t.string :reason_for_down_time
      t.string :last_machine_reset_time
      t.string :remarks
      t.belongs_to :cncoperation, foreign_key: true
      t.belongs_to :cncjob, foreign_key: true
      t.string :no_of_reworks

      t.timestamps
    end
  end
end
