class Material < ApplicationRecord
  belongs_to :cncjob
  belongs_to :tenant
end
