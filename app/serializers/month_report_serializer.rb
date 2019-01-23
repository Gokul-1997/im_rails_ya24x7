class MonthReportSerializer < ActiveModel::Serializer
  attributes :id, :date, :file_path,:tenant_id
  #has_one :tenant

def date
   object.date.strftime("%B")
end


end