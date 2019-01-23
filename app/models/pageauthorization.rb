class Pageauthorization < ApplicationRecord
has_many :menuconfigurations,:dependent => :destroy
end
