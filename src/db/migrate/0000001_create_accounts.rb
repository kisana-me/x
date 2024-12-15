class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, default: ""
      t.string :name_id, null: false
      t.text :bio, null: false, default: ""
      t.string :login_password, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :accounts, :name_id, unique: true
    add_index :accounts, :login_password, unique: true
  end
end
