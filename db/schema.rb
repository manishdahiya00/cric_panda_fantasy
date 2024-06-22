# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_28_105002) do
  create_table "common_contests", force: :cascade do |t|
    t.string "contest_title"
    t.string "contest_image"
    t.string "conditions"
    t.string "rank"
    t.string "prizelist"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_title"], name: "index_common_contests_on_contest_title"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "cid"
    t.string "title"
    t.string "abbr"
    t.string "category"
    t.string "game_format"
    t.boolean "status", default: true
    t.string "status_str"
    t.string "season"
    t.string "date_start"
    t.string "date_end"
    t.string "total_matches"
    t.string "total_rounds"
    t.string "total_teams"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cid"], name: "index_competitions_on_cid"
    t.index ["id"], name: "index_competitions_on_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_categories", force: :cascade do |t|
    t.string "title"
    t.string "gtype"
    t.string "description"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_contest_categories_on_id"
    t.index ["title"], name: "index_contest_categories_on_title"
  end

  create_table "contests", force: :cascade do |t|
    t.string "title"
    t.string "entry_fee"
    t.string "etype"
    t.string "total_spot"
    t.string "description"
    t.integer "contest_category_id"
    t.string "entry_allowed"
    t.string "entry_type"
    t.string "winning_prize"
    t.string "first_prize"
    t.string "winning_percentage"
    t.boolean "status", default: true
    t.string "commission"
    t.string "discount"
    t.string "bonus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_contests_on_id"
    t.index ["title"], name: "index_contests_on_title"
  end

  create_table "filters", force: :cascade do |t|
    t.string "frange"
    t.string "ftype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kycdetails", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "pan_number"
    t.string "dob"
    t.string "photo_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_results", force: :cascade do |t|
    t.string "mid"
    t.string "teama_player1_id"
    t.string "teama_player1_point"
    t.string "teama_player2_id"
    t.string "teama_player2_point"
    t.string "teama_player3_id"
    t.string "teama_player3_point"
    t.string "teama_player4_id"
    t.string "teama_player4_point"
    t.string "teama_player5_id"
    t.string "teama_player5_point"
    t.string "teama_player6_id"
    t.string "teama_player6_point"
    t.string "teama_player7_id"
    t.string "teama_player7_point"
    t.string "teama_player8_id"
    t.string "teama_player8_point"
    t.string "teama_player9_id"
    t.string "teama_player9_point"
    t.string "teama_player10_id"
    t.string "teama_player10_point"
    t.string "teama_player11_id"
    t.string "teama_player11_point"
    t.string "teamb_player1_id"
    t.string "teamb_player1_point"
    t.string "teamb_player2_id"
    t.string "teamb_player2_point"
    t.string "teamb_player3_id"
    t.string "teamb_player3_point"
    t.string "teamb_player4_id"
    t.string "teamb_player4_point"
    t.string "teamb_player5_id"
    t.string "teamb_player5_point"
    t.string "teamb_player6_id"
    t.string "teamb_player6_point"
    t.string "teamb_player7_id"
    t.string "teamb_player7_point"
    t.string "teamb_player8_id"
    t.string "teamb_player8_point"
    t.string "teamb_player9_id"
    t.string "teamb_player9_point"
    t.string "teamb_player10_id"
    t.string "teamb_player10_point"
    t.string "teamb_player11_id"
    t.string "teamb_player11_point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_teams", force: :cascade do |t|
    t.string "mid"
    t.integer "match_id"
    t.string "tid"
    t.integer "team_id"
    t.string "pid"
    t.integer "player_id"
    t.string "name"
    t.string "role"
    t.string "role_str"
    t.string "substitute"
    t.string "playing11"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_match_teams_on_id"
    t.index ["mid"], name: "index_match_teams_on_mid"
    t.index ["name"], name: "index_match_teams_on_name"
  end

  create_table "matches", force: :cascade do |t|
    t.string "mid"
    t.string "cid"
    t.integer "competition_id"
    t.string "title"
    t.string "short_title"
    t.string "subtitle"
    t.string "mnumber"
    t.string "mformat"
    t.string "mformat_str"
    t.boolean "status", default: false
    t.string "mstatus", default: "1"
    t.string "mstatus_str", default: "Scheduled"
    t.string "mstatus_note"
    t.string "domestic"
    t.string "odds_available"
    t.string "game_state", default: "0"
    t.string "game_state_str", default: "Default"
    t.string "date_start"
    t.string "date_end"
    t.string "timestamp_start"
    t.string "timestamp_end"
    t.string "date_start_ist"
    t.string "date_end_ist"
    t.string "venue_id"
    t.string "venue_name"
    t.string "venue_location"
    t.string "venue_country"
    t.string "venue_timezone"
    t.string "teama_id"
    t.string "teama_name"
    t.string "teama_shortname"
    t.string "teama_scores"
    t.string "teama_scoresfull"
    t.text "teama_logourl"
    t.string "teama_overs"
    t.string "teamb_id"
    t.string "teamb_name"
    t.string "teamb_shortname"
    t.string "teamb_scores"
    t.string "teamb_scoresfull"
    t.text "teamb_logourl"
    t.string "teamb_overs"
    t.string "umpires"
    t.string "referee"
    t.string "equation"
    t.string "mlive"
    t.string "result"
    t.string "result_type"
    t.string "win_margin"
    t.string "winning_team_id"
    t.string "commentary"
    t.string "wagon"
    t.string "latest_inning_number"
    t.string "pre_squad"
    t.string "presquad_time"
    t.string "verified"
    t.string "verify_time"
    t.text "toss_text"
    t.string "toss_winner_tid"
    t.string "toss_decision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_matches_on_id"
    t.index ["mid"], name: "index_matches_on_mid"
  end

  create_table "players", force: :cascade do |t|
    t.string "pid"
    t.integer "team_id"
    t.string "title"
    t.string "short_name"
    t.string "full_name"
    t.string "birthdate"
    t.string "country"
    t.string "nationality"
    t.string "playing_role"
    t.string "batting_style"
    t.string "fantasy_player_rating"
    t.string "alt_name"
    t.text "thumb_url"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_players_on_id"
    t.index ["pid"], name: "index_players_on_pid"
    t.index ["title"], name: "index_players_on_title"
  end

  create_table "prizes", force: :cascade do |t|
    t.integer "common_contest_id"
    t.string "rank"
    t.string "amount"
    t.boolean "flexible", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_cards", force: :cascade do |t|
    t.string "mid"
    t.integer "match_id"
    t.text "match_data", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_score_cards_on_id"
    t.index ["match_id"], name: "index_score_cards_on_match_id"
    t.index ["mid"], name: "index_score_cards_on_mid"
  end

  create_table "teams", force: :cascade do |t|
    t.string "tid"
    t.string "title"
    t.string "abbr"
    t.string "sex"
    t.string "typem"
    t.string "country"
    t.string "alt_name"
    t.boolean "status", default: true
    t.text "thumb_url"
    t.text "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_teams_on_id"
    t.index ["tid"], name: "index_teams_on_tid"
    t.index ["title"], name: "index_teams_on_title"
  end

  create_table "user_balances", force: :cascade do |t|
    t.string "unutilized_balance"
    t.string "winning_balance"
    t.string "cash_bonus"
    t.string "total_balance"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_contests", force: :cascade do |t|
    t.string "title"
    t.string "rank"
    t.string "gtype"
    t.integer "user_id"
    t.string "captain_name"
    t.integer "match_id"
    t.string "vcaptain_name"
    t.integer "contest_id"
    t.string "entry_fee"
    t.string "mstatus"
    t.integer "user_team_id"
    t.string "total_spot"
    t.string "winning_prize"
    t.string "entry_type"
    t.string "entry_allowed"
    t.string "totalscore", default: "0.0"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_user_contests_on_id"
    t.index ["user_id"], name: "index_user_contests_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.string "dob"
    t.string "gender"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "pincode"
    t.string "address"
    t.string "kyc_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_teams", force: :cascade do |t|
    t.string "title"
    t.string "gtype"
    t.integer "user_id"
    t.integer "match_id"
    t.integer "contest_id"
    t.string "mstatus"
    t.string "captain_id"
    t.string "vcaptain_id"
    t.string "total_point"
    t.text "player_ids"
    t.string "status", default: "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_fee"
    t.index ["id"], name: "index_user_teams_on_id"
    t.index ["user_id"], name: "index_user_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "social_id"
    t.text "social_token"
    t.string "social_type"
    t.string "social_imgurl"
    t.string "social_email"
    t.string "social_name"
    t.string "mobile_number"
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "security_token"
    t.string "advertising_id"
    t.string "referral_code"
    t.string "version_name"
    t.string "version_code"
    t.string "location"
    t.string "source_ip"
    t.text "fcm_token"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "utm_gclid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dob"
    t.string "gender"
    t.string "state"
    t.string "city"
    t.string "pincode"
    t.boolean "is_kyc_completed", default: false
    t.string "balance", default: "0"
    t.string "wallet_balance", default: "0"
    t.index ["advertising_id"], name: "index_users_on_advertising_id"
    t.index ["device_id"], name: "index_users_on_device_id"
    t.index ["id"], name: "index_users_on_id"
    t.index ["referral_code"], name: "index_users_on_referral_code"
    t.index ["security_token"], name: "index_users_on_security_token"
    t.index ["social_id"], name: "index_users_on_social_id"
    t.index ["utm_medium"], name: "index_users_on_utm_medium"
  end

end
