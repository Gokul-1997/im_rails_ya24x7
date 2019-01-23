class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.time :working_time
      t.decimal :no_of_shift
      t.time :day_start_time
      t.belongs_to :tenant, foreign_key: true

      t.timestamps
    end
  end
end
