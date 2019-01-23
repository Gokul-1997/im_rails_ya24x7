class DeviceMappingSerializer < ActiveModel::Serializer
  attributes :id, :installing_date, :removing_date, :number_of_machine, :reasons, :description, :created_by, :updated_by, :is_active, :deleted_at,:tenant_id
  has_one :tenant
  has_one :device
end
