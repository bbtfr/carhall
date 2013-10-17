class Bcst::TrafficReport < ActiveRecord::Base
  include Share::Userable
  include Share::Providerable
  
  has_many :comments, as: :source, class_name: 'Bcst::Comment'
  belongs_to :at_user, class_name: 'Accounts::User'

  validates_presence_of :user, :provider
  validates_presence_of :content

  extend Share::ImageAttachments
  define_image_method
  
  default_scope { order('id DESC') }
  
  acts_as_api

  api_accessible :base, includes: [:user, :at_user] do |t|
    t.only :id, :content, :created_at, :latitude, :longitude
    t.images :image
    t.add :user, template: :base
    t.add :at_user, template: :base
  end
  
end