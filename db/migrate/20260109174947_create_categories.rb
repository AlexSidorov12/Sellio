class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.string :slug

      t.timestamps
    end
  end
end
