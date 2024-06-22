class CreateComplaints < ActiveRecord::Migration[7.1]
  def change
    create_table :complaints do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
