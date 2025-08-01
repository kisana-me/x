class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.string :aid, null: false, limit: 14
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :token_lookup, null: false
      t.string :token_digest, null: false
      t.datetime :token_expires_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :token_generated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.json :meta, null: false, default: {}
      t.integer :status, limit: 1, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :sessions, :aid, unique: true
    add_index :sessions, :token_lookup, unique: true
  end
end
