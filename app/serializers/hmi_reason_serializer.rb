class HmiReasonSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_path, :is_active
end
