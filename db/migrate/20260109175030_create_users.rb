class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :location

      t.timestamps
    end
  end
end
