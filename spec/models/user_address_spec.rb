require 'rails_helper'

RSpec.describe UserAddress, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
  end

  describe 'validations' do
    it {should validate_presence_of :nickname}
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
    it {should validate_presence_of :street_address_1}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state_province}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :phone_number}
  end
end
