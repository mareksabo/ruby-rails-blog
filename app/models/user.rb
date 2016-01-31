class User < ActiveRecord::Base
  include TheComments::User

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy


  rolify
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def admin?
    has_role?(:admin)
  end

  def comments_admin?
    admin?
  end

  def comments_moderator? comment
    id == comment.holder_id
  end
end
