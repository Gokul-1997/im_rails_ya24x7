class DeviceTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :count, :per_pic_price, :total_price, :purchase_date, :created_by, :updated_by, :deleted_at
end
