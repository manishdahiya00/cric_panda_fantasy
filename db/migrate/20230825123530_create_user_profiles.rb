class CreateUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :mobile_number
      t.string :dob
      t.string :gender
      t.string :country
      t.string :state
      t.string :city
      t.string :pincode
      t.string :address
      t.string :kyc_status

      t.timestamps
    end
  end
end
