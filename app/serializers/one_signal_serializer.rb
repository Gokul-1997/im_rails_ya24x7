class OneSignalSerializer < ActiveModel::Serializer
  attributes :id, :player_id
  has_one :user
  has_one :tenant
end
