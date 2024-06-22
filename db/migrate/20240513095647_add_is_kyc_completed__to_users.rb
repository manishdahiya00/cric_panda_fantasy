class AddIsKycCompletedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_kyc_completed, :boolean, default: false
    add_column :users, :balance, :string,default: "0"
  end
end
