class CreateApprovals < ActiveRecord::Migration[5.0]
  def change
    create_table :approvals do |t|
      t.string :approval_status_name
      t.string :description

      t.timestamps
    end
  end
end
