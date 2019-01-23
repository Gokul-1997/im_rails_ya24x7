class CreateOeeCalculateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :oee_calculate_lists do |t|
      t.string :program_number
      t.string :run_rate
      t.string :parts_count
      t.string :time
      t.references :oee_calculation, foreign_key: true

      t.timestamps
    end
  end
end
