class CreatePrizes < ActiveRecord::Migration[7.1]
  def change
    create_table :prizes do |t|
      t.integer :contest_id
      t.string :rank
      t.string :amount
      t.boolean :flexible, :default => false

      t.timestamps
    end
  end
end
