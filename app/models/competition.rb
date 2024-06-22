class Competition < ApplicationRecord
  has_many :matchs  
  validates :cid, uniqueness: true
end
