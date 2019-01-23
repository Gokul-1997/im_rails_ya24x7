class AddMachineToPlanstatus < ActiveRecord::Migration[5.0]
  def change
    add_reference :planstatuses, :machine, foreign_key: true
    add_column :planstatuses, :last_mail_time, :datetime
   add_column :planstatuses, :mail_status, :boolean
  end
end
