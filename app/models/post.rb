class Post < ActiveRecord::Base
  include TheComments::Commentable

  belongs_to :user

  has_and_belongs_to_many :tags
  validates_presence_of :author,
                        :title,
                        :body
  validates_presence_of :tags_string, :message => 'must have at least one tag'
  resourcify

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

  # Denormalization methods
  # Check the documentation for information on advanced usage
  def commentable_title
    "Undefined Post Title"
  end

  def commentable_url
    "#"
  end

  def commentable_state
    "published"
  end

end
