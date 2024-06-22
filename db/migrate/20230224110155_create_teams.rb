class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string  :tid
      t.string  :title
      t.string  :abbr
      t.string  :sex
      t.string  :typem
      t.string  :country
      t.string  :alt_name
      t.boolean :status, :default => true
      t.text    :thumb_url
      t.text    :logo_url

      t.timestamps
    end
    add_index :teams, :id
    add_index :teams, :title
    add_index :teams, :tid
  end
end
