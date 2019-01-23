class AddMachineIdToNotification < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :machine, foreign_key: true
  end
end
