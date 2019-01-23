class AddMaintananceTimeDummyToMaintananceentry < ActiveRecord::Migration[5.0]
  def change
    add_column :maintananceentries, :maintanance_time_dummy, :string
  end
end
