class AddFieldsToListings < ActiveRecord::Migration[8.1]
  def change
    add_column :listings, :category_id, :bigint
    add_column :listings, :user_id, :bigint
    add_column :listings, :status, :string
    add_column :listings, :condition, :string
    add_column :listings, :contact_email, :string
    add_column :listings, :contact_phone, :string
    add_column :listings, :views, :integer
    add_column :listings, :featured, :boolean
    add_column :listings, :expires_at, :datetime
  end
end
