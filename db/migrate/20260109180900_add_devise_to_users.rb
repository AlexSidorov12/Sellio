class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      # Email already exists from scaffold, so skip it
      # t.string :email, null: false, default: ""
      
      # Add Devise-specific columns (only if they don't exist)
      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end
      
      unless column_exists?(:users, :reset_password_token)
        t.string :reset_password_token
      end
      
      unless column_exists?(:users, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end
      
      unless column_exists?(:users, :remember_created_at)
        t.datetime :remember_created_at
      end
    end
    
    # Add indexes (only if they don't exist)
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end
end
