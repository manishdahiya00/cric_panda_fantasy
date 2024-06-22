class Match < ApplicationRecord
  belongs_to :competition
  has_many :match_teams
  has_many :user_teams
  scope :active, -> {where(status: true).order('created_at desc')}

  validates :mid, uniqueness: true
end
