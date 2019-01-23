class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :device_name, :description, :purchase_date, :created_by, :is_active, :deleted_at
end
