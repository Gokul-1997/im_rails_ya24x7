class AddIsactiveToShift < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :isactive, :boolean
  end
end
