class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.integer :role

      t.timestamps
    end
  end
end
