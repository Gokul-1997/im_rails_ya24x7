class OperatorEntryOee < ApplicationRecord
  belongs_to :cncoperation
  belongs_to :shifttransaction, -> { with_deleted }
  belongs_to :machine, -> { with_deleted }
end
