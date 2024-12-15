class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.text :content, null: false, default: ""
      t.json :cache, null: false, default: {}
      t.references :account, null: false, foreign_key: true
      t.references :post, foreign_key: true
      t.string :name_id, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :posts, :name_id, unique: true
  end
end
