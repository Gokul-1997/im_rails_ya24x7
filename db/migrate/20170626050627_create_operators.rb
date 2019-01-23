class CreateOperators < ActiveRecord::Migration[5.0]
  def change
    create_table :operators do |t|
      t.string :operator_name
      t.string :operator_spec_id
      t.string :description
      t.belongs_to :tenant, foreign_key: true
      t.timestamps
    end
  end
end
