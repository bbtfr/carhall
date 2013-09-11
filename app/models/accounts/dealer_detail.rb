class Accounts::DealerDetail < ActiveRecord::Base
  extend Share::ImageAttachments
  define_image_method
  alias_attribute :authentication_image, :image
  
  attr_accessible :dealer_type_id, :business_scope_ids, :template_ids, 
    :company, :address, :phone, :open_during, :accepted, :authentication_image
  attr_accessible :dealer_type, :business_scopes, :templates 

  validates_presence_of :dealer_type_id, :business_scope_ids,
    :company, :address, :phone, :open_during, :authentication_image

  extend Share::Id2Key

  DealerTypes = %w(洗车美容 专项服务 专修 4S店)
  define_id2key_methods :dealer_type

  BusinessScopes = %w(洗车 美容 轮胎 换油 改装 钣喷 空调 专修 保险)
  define_ids2keys_methods :business_scopes

  Templates = %w(洗车美容 保养专修 团购 近期活动)
  define_ids2keys_methods :templates

  TemplateSyms = %i(cleaning mending bulk_purchasing activity)
  def template_syms
    @template_syms ||= template_ids.map do |id|
      TemplateSyms[id]
    end
  end

  def serializable_hash(options={})
    options = { 
      only: [:dealer_type_id, :business_scope_ids, :company, :address, 
        :phone, :open_during],
      methods: [:dealer_type, :business_scopes],
    }.update(options)
    super(options)
  end

end
