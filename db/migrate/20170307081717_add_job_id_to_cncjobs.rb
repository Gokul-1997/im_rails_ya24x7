class AddJobIdToCncjobs < ActiveRecord::Migration[5.0]
  def change
    add_column :cncjobs, :job_id, :string
  end
end
