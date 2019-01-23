class CreateNodetests < ActiveRecord::Migration[5.0]
  def change
    create_table :nodetests do |t|
      t.string :name
      t.string :m_no

      t.timestamps
    end
  end
end
