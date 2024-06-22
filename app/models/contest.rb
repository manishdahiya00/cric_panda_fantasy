class Contest < ApplicationRecord
  belongs_to :contest_category
  has_many :user_teams
  scope :active, -> {where(status: true).order('created_at desc')}
end
