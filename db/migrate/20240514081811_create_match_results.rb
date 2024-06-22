class CreateMatchResults < ActiveRecord::Migration[7.1]
  def change
    create_table :match_results do |t|
      t.string :mid
      t.string :teama_player1_id
      t.string :teama_player1_point
      t.string :teama_player2_id
      t.string :teama_player2_point
      t.string :teama_player3_id
      t.string :teama_player3_point
      t.string :teama_player4_id
      t.string :teama_player4_point
      t.string :teama_player5_id
      t.string :teama_player5_point
      t.string :teama_player6_id
      t.string :teama_player6_point
      t.string :teama_player7_id
      t.string :teama_player7_point
      t.string :teama_player8_id
      t.string :teama_player8_point
      t.string :teama_player9_id
      t.string :teama_player9_point
      t.string :teama_player10_id
      t.string :teama_player10_point
      t.string :teama_player11_id
      t.string :teama_player11_point
      t.string :teamb_player1_id
      t.string :teamb_player1_point
      t.string :teamb_player2_id
      t.string :teamb_player2_point
      t.string :teamb_player3_id
      t.string :teamb_player3_point
      t.string :teamb_player4_id
      t.string :teamb_player4_point
      t.string :teamb_player5_id
      t.string :teamb_player5_point
      t.string :teamb_player6_id
      t.string :teamb_player6_point
      t.string :teamb_player7_id
      t.string :teamb_player7_point
      t.string :teamb_player8_id
      t.string :teamb_player8_point
      t.string :teamb_player9_id
      t.string :teamb_player9_point
      t.string :teamb_player10_id
      t.string :teamb_player10_point
      t.string :teamb_player11_id
      t.string :teamb_player11_point

      t.timestamps
    end
  end
end
