class CreateKycdetails < ActiveRecord::Migration[7.1]
  def change
    create_table :kycdetails do |t|
      t.integer :user_id
      t.string :name
      t.string :pan_number
      t.string :dob
      t.string :photo_data

      t.timestamps
    end
  end
end
