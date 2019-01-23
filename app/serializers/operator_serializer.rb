class OperatorSerializer < ActiveModel::Serializer
  attributes :id, :operator_name, :operator_spec_id, :description, :tenant_id
end

