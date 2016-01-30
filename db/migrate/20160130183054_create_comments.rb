class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, index: true, foreign_key: true
      t.integer :likes, :default => 0
      t.string :author
      t.text :body

      t.timestamps null: false
    end
  end
end
