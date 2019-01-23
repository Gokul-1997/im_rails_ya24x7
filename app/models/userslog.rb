class Userslog < ApplicationRecord
	acts_as_paranoid
  belongs_to :usertype
  belongs_to :approval
  belongs_to :tenant
  belongs_to :role
  belongs_to :user
end
