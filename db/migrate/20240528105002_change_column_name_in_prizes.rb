class ChangeColumnNameInPrizes < ActiveRecord::Migration[7.1]
  def change
    rename_column :prizes, :contest_id, :common_contest_id
  end
end
