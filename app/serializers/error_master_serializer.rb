class ErrorMasterSerializer < ActiveModel::Serializer
  attributes :id, :error_code, :message, :description
end
