class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :contest
end
