class Operatorworkingdetail < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :shifttransaction, -> { with_deleted }
  belongs_to :machine, -> { with_deleted }
  belongs_to :tenant
  belongs_to :cncoperation
  belongs_to :cncjob
end
