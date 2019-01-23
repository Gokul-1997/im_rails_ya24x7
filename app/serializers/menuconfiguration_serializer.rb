class MenuconfigurationSerializer < ActiveModel::Serializer
  attributes :id,:page_id,:role_id,:pageauthorization_id,:tenant_id	
  #has_one :role
  #has_one :page
  #has_one :pageauthorization
end
