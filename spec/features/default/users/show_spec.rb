require 'rails_helper'

RSpec.describe 'User show page', type: :feature do
  context 'As a regular user' do
    describe 'When I visit my own profile page' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
        @address = @user.user_addresses.create!(nickname: "home", street_address_1: "123 Test St", street_address_2: "test", city: "Testville", state_province: "Test", zip_code: "01234", phone_number:'8154775555')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'has does not have a link if an order is placed' do
        order_1 = @user.orders.create!(status: 2, user_address: @address)
        
        visit profile_path

        within ".address-#{@user.user_addresses.first.id}" do
          expect(page).to_not have_button("Remove Address")
        end
      end

      it 'has a link to add a new address' do
        visit profile_path

        expect(page).to have_link("Add Address")
        within ".address-#{@user.user_addresses.first.id}" do

        end
      end

      it 'has a link to remove a address' do
        
        visit profile_path
        
        within ".address-#{@user.user_addresses.first.id}" do
          expect(page).to have_button("Remove Address")
          
          click_button "Remove Address" 

          expect(current_path).to eq(profile_path)
          expect(page).to have_content(@user.user_addresses.first.street_address_1)
          expect(page).to have_content(@user.user_addresses.first.city)
          expect(page).to have_content(@user.user_addresses.first.state_province)
          expect(page).to have_content(@user.user_addresses.first.zip_code)
        end
      end

      it 'Then I can see all my information, except my password' do
        visit profile_path

        expect(page).to have_content(@user.email)
        expect(page).to have_content(@user.role)
        expect(page).to have_content(@user.active)
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@user.user_addresses.first.street_address_1)
        expect(page).to have_content(@user.user_addresses.first.city)
        expect(page).to have_content(@user.user_addresses.first.state_province)
        expect(page).to have_content(@user.user_addresses.first.zip_code)

        expect(page).to_not have_content(@user.password_digest)
      end

      it 'I see a link to edit my information' do
        visit profile_path

        expect(page).to have_link("Edit Profile")

        click_on "Edit Profile"

        expect(current_path).to eq("/profile/edit")
      end

      describe 'And I have orders placed in the system' do
        it 'I can click on My Orders and navigate to profile/orders' do
          order_1 = @user.orders.create!(status: 0, user_address: @address)

          visit profile_path

          expect(page).to have_link("My Orders")

          click_on "My Orders"

          expect(current_path).to eq(profile_orders_path)
        end
      end
      describe 'And I do not have orders placed in the system' do
        it 'I do not see My Orders link' do
          visit profile_path

          expect(page).to have_no_link("My Orders")
        end
      end
    end
  end
end
