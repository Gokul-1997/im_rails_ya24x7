class AddIsactiveToCncjob < ActiveRecord::Migration[5.0]
  def change
    add_column :cncjobs, :isactive, :boolean
  end
end
