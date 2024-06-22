class ContestCategory < ApplicationRecord
  has_many :contests
  validates :title, uniqueness: true
  scope :active, -> {where(status: true).order('created_at desc')}
end
