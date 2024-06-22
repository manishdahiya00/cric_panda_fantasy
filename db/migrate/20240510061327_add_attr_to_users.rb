class AddAttrToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dob , :string
    add_column :users, :gender,:string
    add_column :users, :state,:string
    add_column :users, :city,:string
    add_column :users, :pincode,:string
  end
end
