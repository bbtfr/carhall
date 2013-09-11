require_relative 'accounts/share/authenticatable'
require_relative 'accounts/share/confirmable'
require_relative 'accounts/share/validatable'
require_relative 'accounts/share/lockable'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :validatable#, :confirmable#, :lockable#, :trackable

  include Share::Acceptable

  # For details
  include Share::Detailable
  alias_method :user_type, :type_sym
  attr_accessor :user_type_id

  # For friendships
  include Share::Friendshipable

  # For avatar
  extend Share::ImageAttachments
  define_avatar_method path: ':rails_root/public/system/users/:attachment/:id_partition/:style/:filename'

  # For posts
  has_many :posts

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :username, :mobile, :description, :avatar
  attr_accessible :detail, :user_type_id

  validates_presence_of :username
  validates_length_of :username, :within => 2..20, :allow_blank => true

  def club
    Club.with_user self
  end

  def serializable_hash(options={})
    options = {
      only: [:id, :username, :mobile, :description],
      methods: [:user_type],
      images: [:avatar]
    }.update(options)
    super(options)
  end

  def detail_hash(options={})
    serializable_hash options.merge(include: :detail)
  end
end
