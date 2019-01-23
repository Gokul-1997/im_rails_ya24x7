class AlarmCode < ApplicationRecord
  has_and_belongs_to_many :machine_series_nos
end
