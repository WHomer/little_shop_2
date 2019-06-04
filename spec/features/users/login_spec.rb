require 'rails_helper'


RSpec.describe 'User can login' do
  describe 'When I go to the login page' do

    before :each do
      @password = BCrypt::Password.create("password", cost: 4)
      @regular_user = User.create!(name: "Regular1", password_digest: @password, role: 0, active: true, email: "reg_1@gmail.com")
      @regular_user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      @password2 = BCrypt::Password.create("password", cost: 4)
      @merchant_user = User.create(name: "Merchant1", password_digest: @password2, role: 1, active: true, email: "merchant_1@gmail.com")
      @merchant_user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      @password3 = BCrypt::Password.create("password", cost: 4)
      @merchant_user = User.create(name: "Admin1", password_digest: @password3, role: 2, active: true, email: "admin_1@gmail.com")
      @merchant_user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
    end

    it 'As a regular user, I can login' do

      visit login_path

      fill_in 'Email', with: "reg_1@gmail.com"
      fill_in 'Password', with: "password"

      click_button('Login')

      expect(current_path).to eq("/profile")
      expect(page).to have_content('You are now logged in.')
    end

    it 'As a merchant user, I can login' do

      visit login_path

      fill_in 'Email', with: "merchant_1@gmail.com"
      fill_in 'Password', with: "password"

      click_button('Login')

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content('You are now logged in.')
    end

    it 'As a admin user, I can login' do

      visit login_path

      fill_in 'Email', with: "admin_1@gmail.com"
      fill_in 'Password', with: "password"

      click_button('Login')

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are now logged in.')
    end

    it 'shows error message if credentials are bad' do
      visit login_path

      fill_in 'Email', with: "reg_@gmail.com"
      fill_in 'Password', with: "password"

      click_button('Login')

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Those are the wrong credentials.')
    end
  end

  context 'As a regular user' do
    describe 'When I visit the login page' do
      before :each do
        @regular_user = User.create!(name: "Regular1", password: 'test', role: 0, active: true, email: "reg_1@gmail.com")
        @regular_user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)
      end

      it 'It redirects me to my profile page' do
        visit login_path

        expect(current_path).to eq(profile_path)
        expect(page).to have_content('You have already logged in.')
      end
    end
  end

  context 'As a merchant user' do
    describe 'When I visit the login page' do
      before :each do
        @merchant = User.create!(name: "Merchant", password_digest: "password", role: 1, active: true, email: "merchant@gmail.com")
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'It redirects me to my profile page' do
        visit login_path

        expect(current_path).to eq(dashboard_path)
        expect(page).to have_content('You have already logged in.')
      end
    end
  end

  context 'As a admin user' do
    describe 'When I visit the login page' do
      before :each do
        @admin = User.create!(name: "Admin", password_digest: "password", role: 2, active: true, email: "merchant@gmail.com")
        @admin.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      end

      it 'It redirects me to my profile page' do
        visit login_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content('You have already logged in.')
      end
    end
  end
end