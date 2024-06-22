class User < ApplicationRecord
  has_many :user_teams
  has_many :user_contests
end
