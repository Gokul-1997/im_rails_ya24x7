class AddIsactiveToCncvendor < ActiveRecord::Migration[5.0]
  def change
    add_column :cncvendors, :isactive, :boolean
  end
end
