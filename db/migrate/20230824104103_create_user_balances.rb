class CreateUserBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :user_balances do |t|
      t.string :unutilized_balance
      t.string :winning_balance
      t.string :cash_bonus
      t.string :total_balance
      t.integer :user_id

      t.timestamps
    end
  end
end
