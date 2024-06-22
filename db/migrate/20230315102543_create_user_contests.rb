class CreateUserContests < ActiveRecord::Migration[7.1]
  def change
    create_table :user_contests do |t|
      t.string  :title
      t.string  :rank
      t.string  :gtype
      t.integer :user_id
      t.string  :captain_name
      t.integer :match_id
      t.string  :vcaptain_name
      t.integer :contest_id
      t.string  :entry_fee
      t.string  :mstatus
      t.integer :user_team_id
      t.string  :total_spot
      t.string  :winning_prize
      t.string  :entry_type
      t.string  :entry_allowed
      t.string  :totalscore, :default => "0.0"
      t.boolean :status, :default => true

      t.timestamps
    end
    add_index :user_contests, :id
    add_index :user_contests, :user_id
  end
end
