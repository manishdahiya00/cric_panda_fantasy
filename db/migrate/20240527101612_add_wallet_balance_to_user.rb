class AddWalletBalanceToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wallet_balance, :string,default:"0"
  end
end
