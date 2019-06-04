require 'rails_helper'

RSpec.describe 'As a Registered User', type: :feature do
  include ActiveSupport::Testing::TimeHelpers

  describe 'When I visit my own Orders page' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_1 = create(:user)
      @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_2 = create(:user)
      @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_1)
      @item_4 = create(:item, user: @merchant_2)
      @item_5 = create(:item, user: @merchant_2)
      @item_6 = create(:item, user: @merchant_2)
      travel_to Time.zone.local(2019, 04, 11, 8, 00, 00)
      @order_1 = create(:order, user: @user, user_address: @address)
      travel_to Time.zone.local(2019, 05, 10, 18, 00, 00)
      @order_2 = create(:order, user: @user, user_address: @address)
      travel_to Time.zone.local(2019, 05, 02, 12, 00, 00)
      @order_3 = create(:order, user: @user, user_address: @address)
      travel_to Time.zone.local(2018, 01, 15, 14, 00, 00)
      @order_4 = create(:order, user: @user, user_address: @address)
      travel_to Time.zone.local(2019, 04, 12, 8, 00, 00)
      @order_1.update(status: 2)
      travel_to Time.zone.local(2019, 05, 11, 18, 00, 00)
      @order_2.update(status: 2)
      travel_to Time.zone.local(2019, 05, 03, 12, 00, 00)
      @order_3.update(status: 2)
      travel_to Time.zone.local(2018, 01, 16, 14, 00, 00)
      @order_4.update(status: 2)
      travel_back
      order_item_1 = create(:order_item, order: @order_1, item: @item_1)
      order_item_2 = create(:order_item, order: @order_1, item: @item_2)
      order_item_3 = create(:order_item, order: @order_2, item: @item_2)
      order_item_4 = create(:order_item, order: @order_2, item: @item_3)
      order_item_5 = create(:order_item, order: @order_2, item: @item_5)
      order_item_6 = create(:order_item, order: @order_3, item: @item_1)
      order_item_7 = create(:order_item, order: @order_3, item: @item_6)
      order_item_8 = create(:order_item, order: @order_4, item: @item_5)
      order_item_9 = create(:order_item, order: @order_4, item: @item_2)
      order_item_10 = create(:order_item, order: @order_4, item: @item_3)
      order_item_11 = create(:order_item, order: @order_4, item: @item_1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I see all my orders' do
      visit profile_orders_path

      expect(page).to have_content("#{@user.name}'s Orders")

      expect(page).to have_css("#order-#{@order_1.id}")
      expect(page).to have_css("#order-#{@order_2.id}")
      expect(page).to have_css("#order-#{@order_3.id}")
      expect(page).to have_css("#order-#{@order_4.id}")
    end

    it 'I see all information for each order' do
      visit profile_orders_path

      within("#order-#{@order_1.id}") do
        expect(page).to have_link("Order ID: #{@order_1.id}")
        expect(page).to have_content("Date Made: April 11, 2019")
        expect(page).to have_content("Last Updated: April 12, 2019")
        expect(page).to have_content("Current Status: Shipped")
        expect(page).to have_content("Number of Items: 2")
        expect(page).to have_content("Grand Total: $19.98")
      end

      within("#order-#{@order_2.id}") do
        expect(page).to have_link("Order ID: #{@order_2.id}")
        expect(page).to have_content("Date Made: May 10, 2019")
        expect(page).to have_content("Last Updated: May 11, 2019")
        expect(page).to have_content("Current Status: Shipped")
        expect(page).to have_content("Number of Items: 3")
        expect(page).to have_content("Grand Total: $29.97")
      end

      within("#order-#{@order_3.id}") do
        expect(page).to have_link("Order ID: #{@order_3.id}")
        expect(page).to have_content("Date Made: May 2, 2019")
        expect(page).to have_content("Last Updated: May 3, 2019")
        expect(page).to have_content("Current Status: Shipped")
        expect(page).to have_content("Number of Items: 2")
        expect(page).to have_content("Grand Total: $19.98")
      end

      within("#order-#{@order_4.id}") do
        expect(page).to have_link("Order ID: #{@order_4.id}")
        expect(page).to have_content("Date Made: January 15, 2018")
        expect(page).to have_content("Last Updated: January 16, 2018")
        expect(page).to have_content("Current Status: Shipped")
        expect(page).to have_content("Number of Items: 4")
        expect(page).to have_content("Grand Total: $39.96")
      end
    end

    it 'I see no items if I have no orders' do
      user = User.create!(email: "not_test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_orders_path

      expect(page).to have_content("#{user.name}'s Orders")

      expect(page).to_not have_css("#order-\d")

      expect(page).to have_content("You haven't made any orders yet!")
    end

    it 'Has a link to the show page for each Order' do
      visit profile_orders_path
      click_on("Order ID: #{@order_1.id}")
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")

      visit profile_orders_path
      click_on("Order ID: #{@order_2.id}")
      expect(current_path).to eq("/profile/orders/#{@order_2.id}")

      visit profile_orders_path
      click_on("Order ID: #{@order_3.id}")
      expect(current_path).to eq("/profile/orders/#{@order_3.id}")

      visit profile_orders_path
      click_on("Order ID: #{@order_4.id}")
      expect(current_path).to eq("/profile/orders/#{@order_4.id}")
    end
  end
end
