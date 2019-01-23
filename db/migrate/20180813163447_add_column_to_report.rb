class AddColumnToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :is_sent, :boolean
  end
end
