class Tips::Order < ActiveRecord::Base
  # For details
  include Share::Detailable

  include Tips::Statable
  include Share::Userable
  belongs_to :user, counter_cache: true, class_name: 'Accounts::User'

  include Share::Dealerable
  belongs_to :dealer, counter_cache: true, class_name: 'Accounts::Dealer'
  has_one :review

  validates_presence_of :source, :user 
  
  include Share::Queryable
  define_queryable_column :user_mobile, :user_plate_num

  default_scope { order('id DESC') }
  
  before_create do
    self.dealer_id = source.dealer_id
    self.title = set_title
    self.cost = set_cost
  end

  before_save do
    self.user_mobile = user.mobile
    self.user_plate_num = user.plate_num
  end

  def set_title
    "#{source.title}#{I18n.t(".times", count: count) if count}" 
  end

  def set_cost
    cost = source.vip_price if source.respond_to? :vip_price
    cost *= count if count
  end

  def order_type
    return :order unless type
    type.demodulize.underscore.to_sym
  end

  def to_base_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :title, :state_id, :state, :cost, 
        :created_at, :order_type, :dealer_id
      json.builder! self, :user, :base
    end
  end

  def to_list_builder
    json = to_base_builder
    json.builder! self, :dealer, :base
    json.has_review review.present?
    json.builder! self, :review, :without_order
    json
  end

  def to_detail_builder
    json = to_base_builder
    json.builder! self, :source, :base
    json
  end

end
