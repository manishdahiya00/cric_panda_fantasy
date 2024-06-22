class Player < ApplicationRecord
  belongs_to :team
  has_many :match_team
  validates :pid, uniqueness: true
end
