class CreateUserDevise < ActiveRecord::Migration
  def change
    create_table :user_devise do |t|
      t.references :user
      t.string :sys
      t.string :udid
      t.string :client_token
      
      t.timestamps
    end

    add_index :user_devise, :user_id

  end
end
