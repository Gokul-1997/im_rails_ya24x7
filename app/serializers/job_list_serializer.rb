class JobListSerializer < ActiveModel::Serializer
  attributes :id, :client_dc_no, :j_name, :j_id, :fresh_pecs, :rework_pecs, :reject_pecs, :notes
  has_one :cncclient
end
