class AddDowntimeToOperatorEntryOee < ActiveRecord::Migration[5.0]
  def change
    add_column :operator_entry_oees, :downtime, :string
  end
end
