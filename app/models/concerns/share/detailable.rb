module Share::Detailable
  extend ActiveSupport::Concern

  # Fake detail
  def detail; OpenStruct.new; end
  def detail_attributes= hash=nil; end

  module ClassMethods
    def set_detail_class klass, options={}
      cattr_accessor :detail_class
      self.detail_class = klass

      belongs_to :detail, class_name: klass, autosave: true, dependent: :destroy
      accepts_nested_attributes_for :detail, allow_destroy: true, update_only: true

      define_method :detail= do |args|
        if args.kind_of? klass
          super args
        else
          self.detail_attributes = args
        end
      end

      define_method :autobuild_detail do
        detail || build_detail
      end

      detail_delegates = (klass.attribute_names - attribute_names)
      delegate *detail_delegates, to: :detail, allow_nil: true
      delegate *detail_delegates.map{ |d| :"#{d}=" }, to: :autobuild_detail
    end
  end

end
