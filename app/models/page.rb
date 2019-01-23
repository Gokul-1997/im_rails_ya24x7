class Page < ApplicationRecord
has_many :menuconfigurations,:dependent => :destroy
  belongs_to :companytype

  def self.access_controll(params)
  	where(parent_page_id:nil).map do |page|
  		parent_page = page
  		chile_pages = where(parent_page_id:page.id)
	  		data = {
  			:parent_page=>page,
  			:chile_pages=>chile_pages
  		}
  	end
  end
end
