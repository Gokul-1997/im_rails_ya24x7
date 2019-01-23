class AddMachineTypeToSetting < ActiveRecord::Migration[5.0]
  def change
   add_column :settings, :ethernet, :boolean, :default => false
   add_column :settings, :rs232, :boolean, :default => false
   add_column :settings, :ct, :boolean, :default => false
   add_column :settings, :simans, :boolean, :default => false
   add_column :settings, :option1, :boolean, :default => false
   add_column :settings, :option2, :boolean, :default => false
  end
end
