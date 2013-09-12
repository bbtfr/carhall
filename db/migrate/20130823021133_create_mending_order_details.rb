class CreateMendingOrderDetails < ActiveRecord::Migration
  def change
    create_table :mending_order_details do |t|
      # t.references :source
      t.float    :price
      t.integer  :brand_id
      t.string   :series
      t.string   :plate_num
      t.datetime :arrive_at
      t.integer  :mending_type_id
      t.text     :description
      
    end
    
    # add_index :mending_order_details, :source_id
  end
end
