# API: https://rest.entitysport.com/v2/matches/?status=3&token=e9a8cd857f01e5f88127787d3931b63a

# company_name=justkhelo #https://github.com/krsdata/getset-admin
#https://github.com/krsdata/getset-admin/blob/9c631e750caf88ee497387c1fc4dd11b33fb4138/app/Http/Controllers/Api/ApiController.php#L2193
# https://rest.entitysport.com/v2/matches/?status=1&token=927192a7efcfb0e8d321a41412012af9

#https://github.com/bhagwat007/f.1/blob/c921b4b5a784e7d1f206ca35e29c67ebacd5b9d7/app/src/main/java/com/example/myapplication/match_Activity.java
# https://rest.entitysport.com/v2/matches/?status=1&token=3e0e77298ef32518821a2490c457300c

#upcoming = 1
#completed = 2
#live = 3
#Cancelled = 4
TOKEN = ['3e0e77298ef32518821a2490c457300c','e9a8cd857f01e5f88127787d3931b63a']

namespace :fetch_matches do
  desc "Matches List Task"
  task match_list: :environment do
  	begin
  	  puts "Fetch Matches Start"
  	  require 'rest-client'
  	  # apiurl = "https://rest.entitysport.com/v2/matches/?status=2&token=#{TOKEN.sample}&per_page=50"
  	  apiurl = "https://rest.entitysport.com/v2/matches/?status=1&token=#{TOKEN.sample}&per_page=50"
  	  response = RestClient.get(apiurl, headers={accept: :json})
  	  parse_response = JSON.parse(response)

  	  #puts "ApiResponse Size1:#{response.class}"
  	  #puts "ApiResponse Size2:#{parse_response.class}"

  	  parse_response["response"]["items"].each do |record|
  	  	puts "MatchID: #{record["match_id"]}"

  	  	match_rec = Match.find_by_mid(record["match_id"])
  	  	if !match_rec
  	  	  compt_rec = Competition.find_by_cid(record["competition"]["cid"])
  	  	  if !compt_rec.present?
            compt_rec = competition_create(record["competition"])
  	  	  end
  	  	  venue = record["venue"]
  	  	  teama = record["teama"]
  	  	  teamb = record["teamb"]
          new_match = Match.create(competition_id: compt_rec.id, mid: record["match_id"], cid: record["competition"]["cid"], title: record["title"], short_title: record["short_title"],
            subtitle: record["subtitle"], mnumber: record["match_number"], mformat: record["format"], mformat_str: record["format_str"], mstatus: record["status"],
            mstatus_str: record["status_str"], mstatus_note: record["status_note"], domestic: record["domestic"], odds_available: record["odds_available"],
            game_state: record["game_state"], game_state_str: record["game_state_str"], date_start: record["date_start"], date_end: record["date_end"],
            timestamp_start: record["timestamp_start"], timestamp_end: record["timestamp_end"], date_start_ist: record["date_start_ist"], date_end_ist: record["date_end_ist"],
            presquad_time: record["presquad_time"], wagon: record["wagon"], commentary: record["commentary"],
            venue_id: venue["venue_id"], venue_name: venue["name"], venue_location: venue["location"], venue_country: venue["country"],venue_timezone: venue["timezone"],
            teama_id: teama["team_id"], teama_name: teama["name"], teama_shortname: teama["short_name"], teama_logourl: teama["logo_url"],teama_scores: teama["scores"],teama_scoresfull: teama["scores_full"],teama_overs: teama["overs"],
            teamb_id: teamb["team_id"], teamb_name: teamb["name"], teamb_shortname: teamb["short_name"], teamb_logourl: teamb["logo_url"],teamb_scores: teamb["scores"],teamb_scoresfull: teamb["scores_full"],teamb_overs: teamb["overs"],
            umpires: record["umpires"],referee: record["referee"],equation: record["equation"],mlive: record["live"],result: record["result"],result_type: record["result_type"],win_margin: record["winning_team_id"],latest_inning_number: record["latest_inning_number"],
            pre_squad: record["pre_squad"],verified: record["verified"],verify_time: record["verify_time"],
            toss_text: record["toss"]["text"],toss_winner_tid: record["toss"]["winner"],toss_decision: record["toss"]["decision"],winning_team_id: record["winning_team_id"])
          teama_rec = Team.find_by_tid(teama["team_id"])
          if !teama_rec.present?
            team_create(teama["team_id"])
          end
          teamb_rec = Team.find_by_tid(teamb["team_id"])
          if !teamb_rec.present?
            team_create(teamb["team_id"])
          end
          result = create_match_squad(record["match_id"], new_match.id)
          if result == true
            new_match.update(status: true)
            puts "Match Live:#{new_match.id}"
          end
        else
          match_rec.update(mstatus: record["status"],mstatus_str: record["status_str"])
  	  	end
  	  end

  	rescue Exception => e
  	  puts "API Exception-#{Time.now}-match_list-Error-#{e}"
  	end
  end #Task1 Ends

  desc "Match Squad Task"
  task match_squad: :environment do
    begin
      matches = Match.all.order('created_at desc')
      matches.each do |match|
        result = create_match_squad(match.mid, match.id)
        if result == true
          match.update(status: true)
          puts "Match Live:#{match.id}"
        else
          match.update(status: false)
          puts "Match Pause:#{match.id}"
        end
      end

    rescue Exception => e
      puts "API Exception-#{Time.now}-match_squad-Error-#{e}"
    end
  end #Task2 Ends

  def competition_create(comptrec)
    puts "Hello from competition_create:#{comptrec["cid"]}"
    #comptrec = record["competition"]
    compt_rec = Competition.create(cid: comptrec["cid"], title: comptrec["title"], abbr: comptrec["abbr"],
     category: comptrec["category"], game_format: comptrec["match_format"], status_str: comptrec["status"],
     season: comptrec["season"], date_start: comptrec["datestart"], date_end: comptrec["dateend"], total_matches: comptrec["total_matches"],
     total_rounds: comptrec["total_rounds"], total_teams: comptrec["total_teams"], country: comptrec["country"])
    return compt_rec
  end

  def team_create(team_id)
    puts "Hello from team_create:#{team_id}"
    begin
      require 'rest-client'
      apiurl = "https://rest.entitysport.com/v2/teams/#{team_id}?token=#{TOKEN.sample}"
      response = RestClient.get(apiurl, headers={accept: :json})
      parse_response = JSON.parse(response)
      team_res = parse_response["response"]

      team_rec = Team.create(tid: team_res["tid"], title: team_res["title"], abbr: team_res["abbr"], sex: team_res["sex"],
        alt_name: team_res["alt_name"], typem: team_res["type"], country: team_res["country"], thumb_url: team_res["thumb_url"], logo_url: team_res["logo_url"])

    rescue Exception => e
      puts "API Exception-#{Time.now}-team_create-Error-#{e}"
    end
  end

  def create_match_squad(mid, match_id)
    puts "Hello from create_match_squad:#{mid} | #{match_id}"
    begin
      result = false
      require 'rest-client'
      apiurl = "https://rest.entitysport.com/v2/matches/#{mid}/squads?token=#{TOKEN.sample}"
      response = RestClient.get(apiurl, headers={accept: :json})
      parse_response = JSON.parse(response)

      parse_response["response"]["players"].each do |record|
        player = Player.find_by_pid(record["pid"])
        if !player.present?
          player_rec = Player.create(pid: record["pid"], team_id: 1, title: record["title"], short_name: record["short_name"], full_name: record["first_name"],
           birthdate: record["birthdate"], country: record["country"], nationality: record["nationality"], playing_role: record["playing_role"],
           batting_style: record["batting_style"], fantasy_player_rating: record["fantasy_player_rating"], alt_name: record["alt_name"], thumb_url: record["thumb_url"])
        end
        result = true
      end

      parse_response["response"]["teama"]["squads"].each do |record|
        match_team = MatchTeam.where("mid = ? AND pid = ? AND tid = ?", mid, record["player_id"], parse_response["response"]["teama"]["team_id"])
        if !match_team.present?
          player = Player.find_by_pid(record["player_id"])
          #puts"playerA:#{player.team_id}"
          teama = Team.find_by_tid(parse_response["response"]["teama"]["team_id"])
          player.update(team_id: teama.id)
          #puts"playerA2:#{player.team_id}"
          team_rec = MatchTeam.create(mid: mid, match_id: match_id, tid: parse_response["response"]["teama"]["team_id"], team_id: teama.id, playing11: record["playing11"],
           pid: record["player_id"], player_id: player.id, name: record["name"], role: record["role"], role_str: record["role_str"], substitute: record["substitute"])
        end
      end

      parse_response["response"]["teamb"]["squads"].each do |record|
        match_team = MatchTeam.where("mid = ? AND pid = ? AND tid = ?", mid, record["player_id"], parse_response["response"]["teamb"]["team_id"])
        if !match_team.present?
          player = Player.find_by_pid(record["player_id"])
          #puts"playerB:#{player.team_id}"
          teamb = Team.find_by_tid(parse_response["response"]["teamb"]["team_id"])
          player.update(team_id: teamb.id)
          #puts"playerB2:#{player.team_id}"
          team_rec = MatchTeam.create(mid: mid, match_id: match_id, tid: parse_response["response"]["teamb"]["team_id"], team_id: teamb.id, playing11: record["playing11"],
           pid: record["player_id"], player_id: player.id, name: record["name"], role: record["role"], role_str: record["role_str"], substitute: record["substitute"])
        end
      end

      return result

    rescue Exception => e
      puts "API Exception-#{Time.now}-create_match_squad-Error-#{e}"
      return false
    end
  end

end
