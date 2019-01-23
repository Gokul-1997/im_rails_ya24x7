class UserSerializer < ActiveModel::Serializer
  attributes :id ,:first_name,:last_name,:email_id,:phone_number,:remarks,:usertype_id,:approval_id,:tenant,:role_id,:isactive
  #belongs_to :tenant
  
  #def role_name
  #  Role.find(object.role_id).role_name
  #end
end
