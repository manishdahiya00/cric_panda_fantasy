class AddAttrToUserTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :user_teams, :entry_fee, :integer
  end
end
