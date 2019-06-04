require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when i click a new Users link' do
    before :each do
      @admin_1 = User.create!(email: "ron_admin@gmail.com", password: "12345", role: 2, active: true, name: "Ron admin")
      @admin_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_1 = User.create!(email: "jon_mer@gmail.com", password: "12345", role: 1, active: true, name: "Jon a")
      @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_2 = User.create!(email: "ron_mer@gmail.com", password: "12345", role: 1, active: true, name: "Ron b")
      @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @user_1 = User.create!(email: "user1@gmail.com", password: "12345", role: 0, active: true, name: "Jon 1")
      @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @user_2 = User.create!(email: "user2@gmail.com", password: "12345", role: 0, active: true, name: "Ron 2")
      @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @user_3 = User.create!(email: "user3@gmail.com", password: "12345", role: 0, active: true, name: "Jon 3")
      @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_1)
    end

    it 'shows all users who are not admins' do
      visit root_path

      click_on 'Users'
      
      expect(current_path).to eq(admin_users_path)

      within "#user-#{@user_1.id}" do
        expect(page).to have_content(@user_1.name)
        expect(page).to have_link(@user_1.name)
        expect(page).to have_content(@user_1.created_at)
        expect(page).to have_button('Upgrade to Merchant')
      end
      within "#user-#{@user_2.id}" do
        expect(page).to have_content(@user_2.name)
        expect(page).to have_link(@user_2.name)
        expect(page).to have_content(@user_2.created_at)
        expect(page).to have_button('Upgrade to Merchant')
      end
      within "#user-#{@user_3.id}" do
        expect(page).to have_content(@user_3.name)
        expect(page).to have_link(@user_3.name)
        expect(page).to have_content(@user_3.created_at)
        expect(page).to have_button('Upgrade to Merchant')
      end

      expect(page).to have_no_content(@merchant_1.name)
      expect(page).to have_no_content(@merchant_2.name)
      expect(page).to have_no_content(@admin_1.email)
    end
  end
end