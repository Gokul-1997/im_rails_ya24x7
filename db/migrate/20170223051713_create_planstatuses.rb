class CreatePlanstatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :planstatuses do |t|
      t.string :planstatus_name
      t.string :description

      t.timestamps
    end
  end
end
