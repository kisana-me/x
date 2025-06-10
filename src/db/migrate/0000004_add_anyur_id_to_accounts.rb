class AddAnyurIdToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :anyur_id, :string, null: true
    add_index :accounts, :anyur_id, unique: true
  end
end
