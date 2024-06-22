class MatchTeam < ApplicationRecord
  #enum :role, {wk: 0, bat: 1, all: 2, bowl: 3}
  belongs_to :match
  belongs_to :team
  belongs_to :player

  validates_uniqueness_of :mid, scope: :pid
end
