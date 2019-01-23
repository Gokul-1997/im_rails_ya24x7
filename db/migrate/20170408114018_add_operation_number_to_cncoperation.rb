class AddOperationNumberToCncoperation < ActiveRecord::Migration[5.0]
  def change
    add_column :cncoperations, :operation_no, :string
  end
end
