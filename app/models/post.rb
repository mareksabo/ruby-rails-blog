class Post < ActiveRecord::Base

  has_and_belongs_to_many :tags
  has_many :comments, -> { order 'created_at ASC' }
  validates_presence_of :author,
                        :title,
                        :body
  validates_presence_of :tags_string, :message => 'must have at least one tag'
  resourcify

  enum comment_type: { 'visible' => 0, 'moderated' => 1, 'forbidden' => 2 }

  def tags_string
    tags.to_a.join(', ')
  end

  def tags_string=(val)
    tags.clear

    val.scan(/\w+/).each do |tag_string|
      tag = Tag.find_by_name tag_string
      tag = Tag.create name: tag_string if tag.nil?
      tags << tag unless tags.include?(tag)
    end
  end
end
