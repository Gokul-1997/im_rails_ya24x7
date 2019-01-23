class CreateJobLists < ActiveRecord::Migration[5.0]
  def change
    create_table :job_lists do |t|
      t.string :client_dc_no
      t.string :j_name
      t.string :j_id
      t.integer :fresh_pecs
      t.integer :rework_pecs
      t.integer :reject_pecs
      t.string :notes
      t.boolean :completed_status 
      t.belongs_to :cncclient, foreign_key: true

      t.timestamps
    end
  end
end
