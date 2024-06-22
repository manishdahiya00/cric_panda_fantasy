class CreateMatchTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :match_teams do |t|
      t.string  :mid
      t.integer :match_id
      t.string  :tid
      t.integer :team_id
      t.string  :pid
      t.integer :player_id
      t.string  :name
      t.string  :role
      t.string  :role_str
      t.string  :substitute
      t.string  :playing11

      t.timestamps
    end
    add_index :match_teams, :id
    add_index :match_teams, :name
    add_index :match_teams, :mid
  end
end
