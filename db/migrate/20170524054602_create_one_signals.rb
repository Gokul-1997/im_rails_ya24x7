class CreateOneSignals < ActiveRecord::Migration[5.0]
  def change
    create_table :one_signals do |t|
      t.string :player_id
      t.belongs_to :user, foreign_key: true
      t.belongs_to :tenant, foreign_key: true
      t.timestamps
    end
  end
end
