class CreateUserAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_addresses do |t|
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :state_province
      t.string :zip_code
      t.string :phone_number

      t.timestamps
    end
  end
end
