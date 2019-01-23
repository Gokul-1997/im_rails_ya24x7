class ShiftPart < ApplicationRecord
  def self.parrrt_create
       8.times do 
          ShiftPart.create(date: '22-01-2019', machine_id: 9, shifttransaction_id: 5, program_number: '923', part: '1', status: 1)
       end
   end
end
