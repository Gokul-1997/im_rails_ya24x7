class AddPasswordDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :default, :string
    #remove_column :users, :password
  end
end
