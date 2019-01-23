class CreateHmiMachineDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :hmi_machine_details do |t|
      t.string :job_id
      t.string :program_number
      t.integer :parts_count
      t.belongs_to :operator, foreign_key: true
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
