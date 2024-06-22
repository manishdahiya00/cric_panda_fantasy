class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string  :pid
      t.integer :team_id
      t.string  :title
      t.string  :short_name
      t.string  :full_name
      t.string  :birthdate
      t.string  :country
      t.string  :nationality
      t.string  :playing_role
      t.string  :batting_style
      t.string  :fantasy_player_rating
      t.string  :alt_name
      t.text    :thumb_url
      t.boolean :status, :default => true

      t.timestamps
    end
    add_index :players, :id
    add_index :players, :title
    add_index :players, :pid
  end
end
