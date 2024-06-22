class CreateCommonContests < ActiveRecord::Migration[7.1]
  def change
    create_table :common_contests do |t|
      t.string :contest_title
      t.string :contest_image
      t.string :conditions
      t.string :rank
      t.string :prizelist
      t.boolean :status, :default => true

      t.timestamps
    end
    add_index :common_contests, :contest_title
  end
end
