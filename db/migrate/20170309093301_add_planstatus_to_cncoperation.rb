class AddPlanstatusToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_reference :cncoperations, :planstatus, foreign_key: true
  end
end
