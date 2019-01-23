class Removefieldfromcncoperation < ActiveRecord::Migration[5.0]

  def change
remove_column :cncoperations, :plan_status

 
    

  end
end
