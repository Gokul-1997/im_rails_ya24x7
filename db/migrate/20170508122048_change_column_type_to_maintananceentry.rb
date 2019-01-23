class ChangeColumnTypeToMaintananceentry < ActiveRecord::Migration[5.0]
  def change
    change_table :maintananceentries do |t|
      t.change :maintanance_time,:string
    end
  end
end
