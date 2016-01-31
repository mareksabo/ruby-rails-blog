class AddCommentIsApproved < ActiveRecord::Migration
  def change
    add_column :comments, :is_approved, :boolean, :default => false
    add_column :posts, :comment_type, :integer, :default => 0
  end
end
