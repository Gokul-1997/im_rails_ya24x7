class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :page_name
      t.string :icon
      t.string :url
      t.integer :parent_page_id
      t.belongs_to :usertype, foreign_key: true

      t.timestamps
    end
  end
end
