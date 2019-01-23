class PreMonthlyLog < ApplicationRecord
  belongs_to :machine, -> { with_deleted }
end
