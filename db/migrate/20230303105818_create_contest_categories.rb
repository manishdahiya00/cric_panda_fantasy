class CreateContestCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :contest_categories do |t|
      t.string  :title
      t.string  :gtype
      t.string  :description
      t.boolean :status, :default => true

      t.timestamps
    end
    add_index :contest_categories, :id
    add_index :contest_categories, :title
  end
end
