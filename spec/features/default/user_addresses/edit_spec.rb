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

      fill_in "Nickname", with: "Sisters House"
      fill_in "Street address 1", with: "11 south st."
      fill_in "Street address 2", with: "apt 220"
      fill_in "City", with: "Denver"
      fill_in "State province", with: "CO"
      fill_in "Zip", with: "2394812034"
      fill_in "Phone", with: "8888888888"

      click_button 'Save Address'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content("Sisters House")

      within ".address-#{address.id}" do
        expect(page).to have_content("11 south st.")
        expect(page).to have_content("apt 220")
        expect(page).to have_content("Denver")
        expect(page).to have_content("CO")
        expect(page).to have_content("2394812034")
        expect(page).to have_content("8888888888")
      end
    end
  end
end