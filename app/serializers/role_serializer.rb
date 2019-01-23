class RoleSerializer < ActiveModel::Serializer
  attributes :id,:role_name,:tenant_id
  belongs_to :tenant
end
