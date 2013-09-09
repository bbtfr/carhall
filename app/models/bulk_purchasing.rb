class BulkPurchasing < ActiveRecord::Base
  belongs_to :dealer
  has_many :bulk_purchasing_orders, as: :source
  alias_attribute :orders, :bulk_purchasing_orders
  has_many :reviews, through: :bulk_purchasing_orders

  extend Share::ImageAttachments
  define_image_method

  attr_accessible :title, :bulk_purchasing_type_id, :expire_at, :price, :vip_price, :description, :image

  validates_presence_of :title, :bulk_purchasing_type_id, :expire_at, :price, :vip_price

  def expire_at_before_type_cast
    expire_at.strftime("%Y-%m-%d %H:%M") if expire_at
  end

  extend Share::Id2Key
  BulkPurchasingTypes = %w(洗车 漆面养护 清洁护理)
  define_id2key_methods :bulk_purchasing_type

  include Share::Expiredable

  def serializable_hash(options={})
    options = { 
      only: [:id, :title, :expire_at, :bulk_purchasing_type, 
        :price, :vip_price, :description, :bulk_purchasing_orders_count],
      images: [:image],
      include: [:dealer],
    }.update(options)
    super(options)
  end

end