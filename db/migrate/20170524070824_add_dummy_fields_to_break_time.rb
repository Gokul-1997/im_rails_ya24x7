class AddDummyFieldsToBreakTime < ActiveRecord::Migration[5.0]
  def change
    add_column :break_times, :start_time_dummy, :string
    add_column :break_times, :end_time_dumy, :string
  end
end
