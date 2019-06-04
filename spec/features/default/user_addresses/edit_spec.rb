require 'rails_helper'

RSpec.describe 'New address form' do
  context 'as a default user' do
    before :each do
      @user_1 = User.create!(name: "default_user", role: 0, active: true, password_digest: "8320280282", email: "default_user@gmail.com" )
      address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it 'can create a new address' do
      address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      visit profile_path

      within ".address-#{address.id}" do
        click_on "Edit Address"
      end

      element = find('#user_address_nickname')

      fill_in "user_address_nickname", with: "Sisters House"
      fill_in "user_address_street_address_1", with: "11 south st."
      fill_in "user_address_street_address_2", with: "apt 220"
      fill_in "user_address_city", with: "Denver"
      fill_in "user_address_state_province", with: "CO"
      fill_in "user_address_zip_code", with: "2394812034"
      fill_in "user_address_phone_number", with: "8888888888"
      
      click_on 'Save Address'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Sisters House")
    end
  end
end