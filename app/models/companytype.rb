class Companytype < ApplicationRecord
has_many :tenants,:dependent => :destroy
has_many :pages,:dependent => :destroy
end
