class BreakTime < ApplicationRecord
  belongs_to :shifttransaction, -> { with_deleted }
end
