class OneSignal < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :tenant
end
