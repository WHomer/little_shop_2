class AddUserToUserAddresses < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_addresses, :user, foreign_key: true
  end
end
