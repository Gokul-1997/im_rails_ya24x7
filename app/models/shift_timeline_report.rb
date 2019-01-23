class ShiftTimelineReport < ApplicationRecord
  belongs_to :machine
  belongs_to :shifttransaction
end
