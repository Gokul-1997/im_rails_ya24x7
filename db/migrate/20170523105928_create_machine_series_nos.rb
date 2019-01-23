class CreateMachineSeriesNos < ActiveRecord::Migration[5.0]
  def change
    create_table :machine_series_nos do |t|
      t.string :number
      t.string :controller_name

      t.timestamps
    end
  end
end
