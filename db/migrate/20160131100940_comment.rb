class Comment < ActiveRecord::Migration
  def change
    remove_column :comments, :likes
  end
end
