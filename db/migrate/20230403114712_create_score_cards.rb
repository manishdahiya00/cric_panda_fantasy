class CreateScoreCards < ActiveRecord::Migration[7.1]
  def change
    create_table :score_cards do |t|
      t.string  :mid
      t.integer :match_id
      t.text    :match_data, limit: 16777215

      t.timestamps
    end
    add_index :score_cards, :id
    add_index :score_cards, :mid
    add_index :score_cards, :match_id
  end
end
