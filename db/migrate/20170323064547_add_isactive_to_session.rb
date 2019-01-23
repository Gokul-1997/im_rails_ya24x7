class AddIsactiveToSession < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :isactive, :boolean
  end
end
