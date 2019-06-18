class UserAddress < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :nickname,
                        # :first_name,
                        # :last_name,
                        :street_address_1,
                        :city,
                        :state_province,
                        :zip_code,
                        :phone_number


  def address_orders
    # require 'pry'; binding.pry
    orders.where(status: :shipped)
  end
end
