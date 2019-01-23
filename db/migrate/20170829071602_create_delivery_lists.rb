class CreateDeliveryLists < ActiveRecord::Migration[5.0]
  def change
    create_table :delivery_lists do |t|
      t.string :client_dc_no
      t.string :our_dc_no
      t.string :j_name
      t.string :j_id
      t.integer :fresh_pecs
      t.integer :rework_pecs
      t.integer :reject_pecs
      t.string :notes
      t.belongs_to :cncclient, foreign_key: true
      t.belongs_to :job_list, foreign_key: true

      t.timestamps
    end
  end
end
