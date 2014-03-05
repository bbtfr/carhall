class RenameProviderToAdviserInSalesCases < ActiveRecord::Migration
  def change
    change_table :sales_cases do |t|
      t.rename  :provider, :adviser
      
      t.integer :state_id, default: 1
      t.index   :state_id
      
      t.timestamps
    end
  end
end