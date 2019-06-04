require 'rails_helper'

RSpec.describe 'Merchant show page', type: :feature do
  context 'As a merchant user' do
    describe 'When I visit my dashboard' do
      before :each do
        @merchant = create(:user, role: 1)
        @merchant.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @item_1 = create(:item, user: @merchant)
        @item_2 = create(:item, user: @merchant)
        @item_3 = create(:item, user: @merchant)
        @item_4 = create(:item, user: @merchant)
        @user_1 = create(:user)
        @user_2 = create(:user)
        @user_3 = create(:user)
        @address_1 = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @address_2 = @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @address_3 = @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @order_1 = create(:order, user: @user_1, status: 1, user_address: @address_1)
        @order_2 = create(:order, user: @user_2, status: 1, user_address: @address_1)
        @order_3 = create(:order, user: @user_3, status: 0, user_address: @address_1)
        @order_4 = create(:order, user: @user_3, status: 0, user_address: @address_1)
        OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_2, order: @order_2, quantity: 13, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_3, order: @order_3, quantity: 14, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_3, order: @order_4, quantity: 15, price: 1.99, fulfilled: false)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'I see my profile data' do

        visit dashboard_path

        expect(page).to have_content(@merchant.email)
        expect(page).to have_content(@merchant.role)
        expect(page).to have_content(@merchant.active)
        expect(page).to have_content(@merchant.name)
        expect(page).to_not have_content(@merchant.password_digest)
        expect(page).to_not have_link('Edit Profile')
      end

      it 'displays the orders for items a merchent sells' do
        visit dashboard_path


        within("#order-#{@order_1.id}") do
          expect(page).to have_link("#{@order_1.id}")
          expect(page).to have_content("Date created: #{@order_1.date_made}")
          expect(page).to have_content("Total quantity: #{@order_1.item_count}")
          expect(page).to have_content("Total price: #{@order_1.grand_total}")
        end

        within("#order-#{@order_2.id}") do
          expect(page).to have_link("#{@order_2.id}")
          expect(page).to have_content("Date created: #{@order_2.date_made}")
          expect(page).to have_content("Total quantity: #{@order_2.item_count}")
          expect(page).to have_content("Total price: #{@order_2.grand_total}")
        end

        expect(page).to_not have_link("#{@order_3.id}")
      end

      it 'has a link to redirect to my items page' do
        visit dashboard_path

        click_link('View My Items')

        expect(current_path).to eq(dashboard_items_path)

        expect(page).to have_content("Item Id: #{@item_1.id}")
        expect(page).to have_content("Item Id: #{@item_2.id}")
        expect(page).to have_content("Item Id: #{@item_3.id}")
        expect(page).to have_content("Item Id: #{@item_4.id}")
      end
    end
  end
end
