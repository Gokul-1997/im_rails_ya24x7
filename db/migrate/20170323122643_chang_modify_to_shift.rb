class ChangModifyToShift < ActiveRecord::Migration[5.0]
  def change
  change_table :shifts do |t|
   t.change :no_of_shift,:integer
  end
end
end
