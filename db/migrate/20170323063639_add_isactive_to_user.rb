class AddIsactiveToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :isactive, :boolean
  end
end
