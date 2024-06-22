class Team < ApplicationRecord
  has_many :players
  has_many :match_teams
  validates :tid, uniqueness: true
end
