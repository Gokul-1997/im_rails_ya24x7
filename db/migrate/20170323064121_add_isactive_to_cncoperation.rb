class AddIsactiveToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :isactive, :boolean
  end
end
