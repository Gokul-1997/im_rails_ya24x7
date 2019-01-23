class OperatorAllocationSerializer < ActiveModel::Serializer
  attributes :id, :description,:from_date,:to_date,:created_at,:shifttransaction,:machine
  has_one :operator
  has_one :shifttransaction
  has_one :machine
  has_many :operator_mapping_allocations

  def from_date
  	
    object.from_date.strftime("%d-%m-%Y")
  end

  def to_date
  	
    object.to_date.strftime("%d-%m-%Y")
  end

  def created_at
   object.created_at.localtime.strftime("%d-%m-%Y %I:%M %p")
  end

end
