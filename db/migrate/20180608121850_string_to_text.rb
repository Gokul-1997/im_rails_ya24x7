class StringToText < ActiveRecord::Migration[5.0]
  def change
     change_column :test_machine_logs, :job_id, :text
  end
end
