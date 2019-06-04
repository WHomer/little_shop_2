require 'rails_helper'

RSpec.describe 'within main navigation' do
  context 'as a visitor' do
    describe 'navbar includes the following' do
      it 'a link to return to the welcome / home page of the application ("/")' do
        visit root_path

        within '.navbar' do
          find('img.cheese-icon').click
        end
        expect(current_path).to eq(root_path)
      end

      it 'a link to browse all items for sale ("/items")' do
        visit root_path

        within '.navbar' do
          click_link('Cheese')
        end
        expect(current_path).to eq(items_path)
      end

      it 'a link to see all merchants ("/merchants")' do
        visit root_path

        within '.navbar' do
          click_link('Merchants')
        end
        expect(current_path).to eq(merchants_path)
      end

      it 'a link to my shopping cart ("/cart")' do
        visit root_path

        within '.navbar' do
          click_link('Cart')
        end
        expect(current_path).to eq(carts_path)
      end

      it 'a link to log in ("/login")' do
        visit root_path

        within '.navbar' do
          click_link('Login')
        end
        expect(current_path).to eq(login_path)
      end

      it 'a link to the user registration page ("/register")' do
        visit root_path

        within '.navbar' do
          click_link('Register')
        end
        expect(current_path).to eq(register_path)
      end

      it 'i do not see a link to logout or profile' do
        visit root_path

        within '.navbar' do
          expect(page).to have_no_link('Logout')
          expect(page).to have_no_link('Profile')
          expect(page).to_not have_link('Users')
        end
      end
    end
  end

  context 'as a registered user' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe 'navbar includes the following' do
      it 'a link to return to the welcome / home page of the application ("/")' do
        visit root_path

        within '.navbar' do
          find('img.cheese-icon').click
        end
        expect(current_path).to eq(root_path)
      end

      it 'a link to browse all items for sale ("/items")' do
        visit root_path

        within '.navbar' do
          click_link('Cheese')
        end
        expect(current_path).to eq(items_path)
      end

      it 'a link to see all merchants ("/merchants")' do
        visit root_path

        within '.navbar' do
          click_link('Merchants')
        end
        expect(current_path).to eq(merchants_path)
      end

      it 'a link to my shopping cart ("/cart")' do
        visit root_path

        within '.navbar' do
          click_link('Cart')
        end
        expect(current_path).to eq(carts_path)
      end

      it 'a link to my profile page ("/profile")' do
        visit root_path

        within '.navbar' do
          click_link('Profile')
        end
        expect(current_path).to eq(profile_path)
      end

      it 'a link to log out ("/logout")' do
        visit root_path

        within '.navbar' do
          click_link('Logout')
        end
        expect(current_path).to eq(root_path)
      end

      it 'i do not see a link to log in or register' do
        visit root_path

        within '.navbar' do
          expect(page).to have_no_link('Login')
          expect(page).to have_no_link('Register')
          expect(page).to_not have_link('Users')
        end
      end

      it 'i see text that says Logged in as {user.name}' do
        visit root_path
        within '.navbar' do
          expect(page).to have_content("Logged in as #{@user.name}")
        end
      end
    end
  end

  context 'as a merchant user' do
    describe 'Navbar includes the following' do

      before :each do
        @user_1 = User.create!(email: "test@test.com", password_digest: "t3s7", role: 1, active: true, name: "Testy McTesterson")
        address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      end

      it 'it has a link to My Dashboard' do

      visit root_path

        within '.navbar' do
          expect(page).to have_link('My Dashboard')
        end
      end

      it 'it has a link to logout' do

      visit root_path

        within '.navbar' do
          expect(page).to have_link('Logout')
        end
      end

      it 'doesnt have link for login/logot or shopping cart' do

        visit root_path

        within '.navbar' do
          expect(page).to_not have_link('Login')
          expect(page).to_not have_link('Register')
          expect(page).to_not have_link('Cart')
          expect(page).to_not have_link('Users')
          expect(page).to_not have_content('Cart: 0')
        end
      end
    end
  end

  context 'as a admin user' do
    describe 'Navbar includes the following' do

      before :each do
        @user_1 = User.create!(email: "test@test.com", password_digest: "t3s7", role: 2, active: true, name: "Testy McTesterson")
        address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      end

      it 'it has a link to Users' do

        visit root_path

        within '.navbar' do
          expect(page).to have_link('Users')
        end
      end

      it 'it has a link to My Dashboard' do

      visit root_path

        within '.navbar' do
          expect(page).to have_link('My Dashboard')
          click_on("My Dashboard")
        end
        expect(current_path).to eq(admin_dashboard_path)
      end

      it 'it has a link to logout' do

      visit root_path

        within '.navbar' do
          expect(page).to have_link('Logout')
        end
      end

      it 'doesnt have link for login/logot or shopping cart' do

      visit root_path

        within '.navbar' do
          expect(page).to_not have_link('Login')
          expect(page).to_not have_link('Register')
          expect(page).to_not have_link('Cart')
          expect(page).to_not have_content('Cart: 0')
        end
      end
    end
  end
end

RSpec.describe "Restricted Navigation" do
  context "As a Visitor" do
    describe 'I see 404s' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
        address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @order = create(:order, user: @user, status: 1, user_address: address)

        @merchant = create(:user, role: 1)
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @item = create(:item, user: @merchant)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      end

      it 'When I go to /profile' do
        visit profile_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_edit_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_orders_path
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /dashboard' do
        visit dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_items_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit new_dashboard_item_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit edit_dashboard_item_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /admin' do
        visit admin_users_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_user_path(@user)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_merchant_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end

  context "As a Default User" do
    describe 'I see 404s' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
        address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @order = create(:order, user: @user, status: 1, user_address: address)

        @merchant = create(:user, role: 1)
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @item = create(:item, user: @merchant)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'When I go to /dashboard' do
        visit dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_items_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit new_dashboard_item_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit edit_dashboard_item_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /admin' do
        visit admin_users_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_user_path(@user)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_merchant_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end

  context "As a Merchant" do
    describe 'I see 404s' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
        address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @order = create(:order, user: @user, status: 1, user_address: address)

        @merchant = create(:user, role: 1)
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @item = create(:item, user: @merchant)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'When I go to /profile' do
        visit profile_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_edit_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_orders_path
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /admin' do
        visit admin_users_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_user_path(@user)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit admin_merchant_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /carts' do
        visit carts_path
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end

  context "As an Admin" do

    describe 'I see 404s' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
        address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @order = create(:order, user: @user, status: 1, user_address: address)

        @merchant = create(:user, role: 1)
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @item = create(:item, user: @merchant)

        @admin = create(:user, role: 2)
        @admin.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      end

      it 'When I go to /profile' do
        visit profile_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_edit_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit profile_orders_path
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /dashboard' do
        visit dashboard_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_items_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit new_dashboard_item_path
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit edit_dashboard_item_path(@item)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit dashboard_order_path(@order)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'When I go to /carts' do
        visit carts_path
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end
end
