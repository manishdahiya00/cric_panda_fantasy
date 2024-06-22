class CreateCompetitions < ActiveRecord::Migration[7.1]
  def change
    create_table :competitions do |t|
      t.string  :cid
      t.string  :title
      t.string  :abbr
      t.string  :category
      t.string  :game_format
      t.boolean :status, :default => true
      t.string  :status_str
      t.string  :season
      t.string  :date_start
      t.string  :date_end
      t.string  :total_matches
      t.string  :total_rounds
      t.string  :total_teams
      t.string  :country

      t.timestamps
    end
    add_index :competitions, :id
    add_index :competitions, :cid
  end
end
