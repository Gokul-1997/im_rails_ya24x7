class CreateMaintananceentries < ActiveRecord::Migration[5.0]
  def change
    create_table :maintananceentries do |t|
      t.string :maintanance_type
      t.date :maintanance_date
      t.string :service_engineer_name
      t.time :maintanance_time
      t.string :remarks
      t.belongs_to :machine, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
