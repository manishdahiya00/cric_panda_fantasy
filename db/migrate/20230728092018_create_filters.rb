class CreateFilters < ActiveRecord::Migration[7.1]
  def change
    create_table :filters do |t|
      t.string :frange
      t.string :ftype

      t.timestamps
    end
  end
end
