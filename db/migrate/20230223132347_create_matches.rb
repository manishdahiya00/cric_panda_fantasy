class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string  :mid
      t.string  :cid
      t.integer :competition_id
      t.string  :title
      t.string  :short_title
      t.string  :subtitle
      t.string  :mnumber
      t.string  :mformat
      t.string  :mformat_str
      t.boolean :status, :default => false
      t.string  :mstatus, :default => 1
      t.string  :mstatus_str, :default => 'Scheduled'
      t.string  :mstatus_note
      t.string  :domestic
      t.string  :odds_available
      t.string  :game_state, :default => 0
      t.string  :game_state_str, :default => 'Default'
      t.string  :date_start
      t.string  :date_end
      t.string  :timestamp_start
      t.string  :timestamp_end
      t.string  :date_start_ist
      t.string  :date_end_ist

      t.string  :venue_id
      t.string  :venue_name
      t.string  :venue_location
      t.string  :venue_country
      t.string  :venue_timezone

      t.string  :teama_id
      t.string  :teama_name
      t.string  :teama_shortname
      t.string  :teama_scores
      t.string  :teama_scoresfull
      t.text    :teama_logourl
      t.string  :teama_overs

      t.string  :teamb_id
      t.string  :teamb_name
      t.string  :teamb_shortname
      t.string  :teamb_scores
      t.string  :teamb_scoresfull
      t.text    :teamb_logourl
      t.string  :teamb_overs

      t.string  :umpires
      t.string  :referee
      t.string  :equation
      t.string  :mlive
      t.string  :result
      t.string  :result_type
      t.string  :win_margin
      t.string  :winning_team_id
      t.string  :commentary
      t.string  :wagon
      t.string  :latest_inning_number
      t.string  :pre_squad
      t.string  :presquad_time
      t.string  :verified
      t.string  :verify_time

      t.text    :toss_text
      t.string  :toss_winner_tid
      t.string  :toss_decision

      t.timestamps
    end
    add_index :matches, :id
    add_index :matches, :mid
  end
end
