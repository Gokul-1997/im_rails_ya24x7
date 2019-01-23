class StringToInteger < ActiveRecord::Migration[5.0]
  def change
   change_column :test_machine_logs, :parts_count, :integer
  end
end
