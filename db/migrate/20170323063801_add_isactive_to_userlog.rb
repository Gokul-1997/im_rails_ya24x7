class AddIsactiveToUserlog < ActiveRecord::Migration[5.0]
  def change
    add_column :userslogs, :isactive, :boolean
  end
end
