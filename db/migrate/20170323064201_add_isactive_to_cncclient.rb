class AddIsactiveToCncclient < ActiveRecord::Migration[5.0]
  def change
    add_column :cncclients, :isactive, :boolean
  end
end
