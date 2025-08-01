class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :kind, limit: 1, null: false, default: 0

      t.timestamps
    end
    add_index :reactions, [ :account_id, :post_id ], unique: true
  end
end
