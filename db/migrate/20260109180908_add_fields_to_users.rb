class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    # Only add columns if they don't already exist
    unless column_exists?(:users, :name)
      add_column :users, :name, :string
    end
    
    unless column_exists?(:users, :phone)
      add_column :users, :phone, :string
    end
    
    unless column_exists?(:users, :location)
      add_column :users, :location, :string
    end
  end
end
