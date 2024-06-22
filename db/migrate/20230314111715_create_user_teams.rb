class CreateUserTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :user_teams do |t|
      t.string  :title
      t.string  :gtype
      t.integer :user_id
      t.integer :match_id
      t.integer :contest_id
      #t.string  :entry_fee
      t.string  :mstatus
      t.string  :captain_id
      t.string  :vcaptain_id
      t.string  :total_point
      t.text    :player_ids
      #t.string  :rank
      #t.decimal :totalscore, precision: 10, scale: 2, default: "0.0", null: false
      t.string  :status, :default => 'created'

      t.timestamps
    end
    add_index :user_teams, :id
    add_index :user_teams, :user_id
  end
end
