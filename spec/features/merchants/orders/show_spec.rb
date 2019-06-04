require 'rails_helper'

RSpec.describe 'As a merchant', type: :feature do
  describe 'When I visit an order show page from my Dasboard' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 1, active: true, name: "Testy McTesterson")
      address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_1 = create(:user, role: 1)
      @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_2 = create(:user, role: 1)
      @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )

      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_2)

      @order = create(:order, user: @user, user_address: address)

      @order_item_1 = create(:order_item, order: @order, item: @item_1)
      @order_item_2 = create(:order_item, order: @order, item: @item_2)
      @order_item_3 = create(:order_item, order: @order, item: @item_3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_1)
    end

    it 'Displays the Orders User information' do
      visit dashboard_order_path(@order)

      expect(page).to have_content("Name: Testy McTesterson")
      # expect(page).to have_content("Address: 123 Test St, Testville, Test, 01234")
    end

    it 'Displays only my Items in the Order' do
      visit dashboard_order_path(@order)

      within("#item-#{@item_1.id}") do
        expect(page).to have_link(@item_1.name, href: item_path(@item_1))
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
        expect(page).to have_content(@item_1.price)
        expect(page).to have_content(@order_item_1.quantity)
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_link(@item_2.name, href: item_path(@item_2))
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
        expect(page).to have_content(@item_2.price)
        expect(page).to have_content(@order_item_2.quantity)
      end

      expect(page).to_not have_css("#item-#{@item_3.id}")
    end

    it 'Should have a Fulfill button on unfulfilled items, and a disabled button on fulfilled items' do
      @order_item_2.update(fulfilled: true)
      @order_item_2.reload
      visit dashboard_order_path(@order)

      within("#item-#{@item_1.id}") do
        expect(page).to have_button("Fulfill Item")
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_button("Fulfill Item", disabled: true)
        expect(page).to have_content("You have already fulfilled this item!")
      end
    end

    it 'Should not allow me to fulfill an item if the inventory is too low' do
      @order_item_2.update(quantity: 112)
      @order_item_2.reload
      visit dashboard_order_path(@order)

      within("#item-#{@item_2.id}") do
        expect(page).to have_button("Fulfill Item", disabled: true)
        expect(page).to have_content("You do not have enough inventory to fulfill this item!")
      end
    end

    it 'When I fulfill the Item, I see a flash notice, can no longer fulfill the Item, and the Item inventory is reduced' do
      original_inventory = @item_1.inventory
      visit dashboard_order_path(@order)

      within("#item-#{@item_1.id}") do
        click_button "Fulfill Item"
      end

      @item_1.reload

      expect(current_path).to eq(dashboard_order_path(@order))

      expect(page).to have_content("Item '#{@item_1.name}' fulfilled.")

      within("#item-#{@item_1.id}") do
        expect(page).to have_button("Fulfill Item", disabled: true)
        expect(page).to have_content("You have already fulfilled this item!")
      end

      expect(@item_1.inventory).to eq(original_inventory - @order_item_1.quantity)
    end
  end
end
