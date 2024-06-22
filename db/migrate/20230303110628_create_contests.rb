class CreateContests < ActiveRecord::Migration[7.1]
  def change
    create_table :contests do |t|
      t.string  :title
      t.string  :entry_fee
      t.string  :etype #game_type
      t.string  :total_spot
      t.string  :description
      t.integer :contest_category_id
      t.string  :entry_allowed
      t.string  :entry_type
      t.string  :winning_prize
      t.string  :first_prize
      t.string  :winning_percentage
      t.boolean :status, :default => true
      t.string  :commission
      t.string  :discount
      t.string  :bonus

      t.timestamps
    end
    add_index :contests, :id
    add_index :contests, :title
  end
end
