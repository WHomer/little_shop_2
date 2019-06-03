class UserAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :nickname,
                        # :first_name,
                        # :last_name,
                        :street_address_1,
                        :city,
                        :state_province,
                        :zip_code,
                        :phone_number

end
