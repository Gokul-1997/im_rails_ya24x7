class PageSerializer < ActiveModel::Serializer
  attributes :id,:page_name,:icon,:url,:parent_page_id
end
