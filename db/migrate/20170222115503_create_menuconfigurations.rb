class CreateMenuconfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :menuconfigurations do |t|
      t.belongs_to :page, foreign_key: true
      t.belongs_to :role, foreign_key: true
      t.belongs_to :pageauthorization, foreign_key: true
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
