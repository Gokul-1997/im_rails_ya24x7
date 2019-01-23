class AddIsactiveToOperatorworkingdetail < ActiveRecord::Migration[5.0]
  def change
    add_column :operatorworkingdetails, :isactive, :boolean
  end
end
