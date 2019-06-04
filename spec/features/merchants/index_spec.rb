require 'rails_helper'

RSpec.describe 'when visiting the merchants index page' do
  describe 'all merchants are visible' do
    describe 'who are active' do
      before :each do
        @merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
        @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
        @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
        @merchant_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
        @merchant_4.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @merchant_5 = create(:user, role: 1, active: false)
        @merchant_5.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @merchant_6 = create(:user, role: 1, active: false)
        @merchant_6.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @user = create(:user)
        @address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      end

      it 'shows merchant name, city, state, date registered' do
        visit merchants_path

        within "#merchant-#{@merchant_1.id}" do
          expect(page).to have_content(@merchant_1.name)
          # expect(page).to have_content(@merchant_1.city)
          # expect(page).to have_content(@merchant_1.state)
          expect(page).to have_content(@merchant_1.created_at.strftime("%B %d, %Y"))
        end

        within "#merchant-#{@merchant_2.id}" do
          expect(page).to have_content(@merchant_2.name)
          # expect(page).to have_content(@merchant_2.city)
          # expect(page).to have_content(@merchant_2.state)
          expect(page).to have_content(@merchant_2.created_at.strftime("%B %d, %Y"))
        end

        within "#merchant-#{@merchant_3.id}" do
          expect(page).to have_content(@merchant_3.name)
          # expect(page).to have_content(@merchant_3.city)
          # expect(page).to have_content(@merchant_3.state)
          expect(page).to have_content(@merchant_3.created_at.strftime("%B %d, %Y"))
        end

        within "#merchant-#{@merchant_4.id}" do
          expect(page).to have_content(@merchant_4.name)
          # expect(page).to have_content(@merchant_4.city)
          # expect(page).to have_content(@merchant_4.state)
          expect(page).to have_content(@merchant_4.created_at.strftime("%B %d, %Y"))
        end
        expect(page).to_not have_content(@merchant_5.name)
        expect(page).to_not have_content(@merchant_6.name)
      end

      it 'has merchant stats' do
        item_1 = create(:item, user: @merchant_1)
        item_2 = create(:item, user: @merchant_2)
        item_3 = create(:item, user: @merchant_3)
        item_4 = create(:item, user: @merchant_4)
        item_5 = create(:item, user: @merchant_1)
        item_6 = create(:item, user: @merchant_5)
        order_1 = create(:order, user: @user, status: 2, user_address: @address)
        order_2 = create(:order, user: @user, status: 2, user_address: @address)
        order_3 = create(:order, user: @user, status: 2, user_address: @address)
        order_4 = create(:order, user: @user, status: 2, user_address: @address)
        order_5 = create(:order, user: @user, status: 1, user_address: @address)
        order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*60))
        order_item_2 = OrderItem.create!(item: item_2, order: order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*120))
        order_item_3 = OrderItem.create!(item: item_3, order: order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*180))
        order_item_4 = OrderItem.create!(item: item_4, order: order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*240))
        order_item_5 = OrderItem.create!(item: item_1, order: order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*300))
        order_item_6 = OrderItem.create!(item: item_2, order: order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*360))
        order_item_7 = OrderItem.create!(item: item_3, order: order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*420))
        order_item_8 = OrderItem.create!(item: item_1, order: order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*480))
        order_item_9 = OrderItem.create!(item: item_2, order: order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*540))
        order_item_10 = OrderItem.create!(item: item_1, order: order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*600))
        order_item_10 = OrderItem.create!(item: item_5, order: order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*660))
        order_item_11 = OrderItem.create!(item: item_6, order: order_5, quantity: 12, price: item_5.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*720))
        order_item_12 = OrderItem.create!(item: item_5, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + (2*7*24*60*780))

        visit merchants_path

        expect(page.all(".most-sold")[0]).to have_content(@merchant_1.name)
        expect(page.all(".most-sold")[0]).to have_content("700")
        expect(page.all(".most-sold")[1]).to have_content(@merchant_2.name)
        expect(page.all(".most-sold")[1]).to have_content("340")
        expect(page.all(".most-sold")[2]).to have_content(@merchant_3.name)
        expect(page.all(".most-sold")[2]).to have_content("200")

        expect(page.all('.fastest')[0]).to have_content(@merchant_4.name)
        expect(page.all('.fastest')[0]).to have_content('55')
        expect(page.all('.fastest')[1]).to have_content(@merchant_3.name)
        expect(page.all('.fastest')[1]).to have_content('138')
        expect(page.all('.fastest')[2]).to have_content(@merchant_2.name)
        expect(page.all('.fastest')[2]).to have_content('235')

        expect(page.all('.slowest')[0]).to have_content(@merchant_1.name)
        expect(page.all('.slowest')[0]).to have_content('485')
        expect(page.all('.slowest')[1]).to have_content(@merchant_2.name)
        expect(page.all('.slowest')[1]).to have_content('235')
        expect(page.all('.slowest')[2]).to have_content(@merchant_3.name)
        expect(page.all('.slowest')[2]).to have_content('138')

        expect(page.all('.top-states')[0]).to have_content("state 1")
        expect(page.all('.top-states')[0]).to have_content("11")
        # expect(page.all('.top-states')[1]).to have_content("CO")
        # expect(page.all('.top-states')[1]).to have_content("3")
        # expect(page.all('.top-states')[2]).to have_content("MI")
        # expect(page.all('.top-states')[2]).to have_content("2")

        expect(page.all('.top-cities')[0]).to have_content("city 1")
        expect(page.all('.top-cities')[0]).to have_content("11")
        # expect(page.all('.top-cities')[1]).to have_content("Springfield")
        # expect(page.all('.top-cities')[1]).to have_content("3")
        # expect(page.all('.top-cities')[2]).to have_content("Springfield")
        # expect(page.all('.top-cities')[2]).to have_content("2")

        expect(page.all('.top-orders')[0]).to have_content(order_1.user.name)
        expect(page.all('.top-orders')[0]).to have_content(order_1.created_at.strftime("%B %d, %Y"))
        expect(page.all('.top-orders')[0]).to have_content("5")
        expect(page.all('.top-orders')[1]).to have_content(order_2.user.name)
        expect(page.all('.top-orders')[1]).to have_content(order_2.created_at.strftime("%B %d, %Y"))
        expect(page.all('.top-orders')[1]).to have_content('3')
        expect(page.all('.top-orders')[2]).to have_content(order_3.user.name)
        expect(page.all('.top-orders')[2]).to have_content(order_3.created_at.strftime("%B %d, %Y"))
        expect(page.all('.top-orders')[2]).to have_content('2')
      end

    end
    describe 'as an admin ' do
      before :each do
        @admin_1 = User.create!(email: "ron_admin@gmail.com", password: "12345", role: 2, active: true, name: "Ron")
        @admin_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
  
        @m1 = User.create!(email: "jon_mer@gmail.com", password: "12345", role: 1, active: true, name: "Jon a")
        @m1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @m2 = User.create!(email: "ron_mer@gmail.com", password: "12345", role: 1, active: false, name: "Ron b")
        @m2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @user_1 = User.create!(email: "user1@gmail.com", password: "12345", role: 0, active: true, name: "Jon 1")
        @add_1 = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @user_2 = User.create!(email: "user2@gmail.com", password: "12345", role: 0, active: true, name: "Ron 2")
        @add_2 = @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
        @user_3 = User.create!(email: "user3@gmail.com", password: "12345", role: 0, active: true, name: "Jon 3")
        @add_3 = @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
  
        @o1 = Order.create!(user: @user_1, status: 0, user_address: @add_1)
        @o2 = Order.create!(user: @user_1, status: 1, user_address: @add_1)
        @o3 = Order.create!(user: @user_2, status: 2, user_address: @add_2)
        @o4 = Order.create!(user: @user_2, status: 3, user_address: @add_2)
        @o5 = Order.create!(user: @user_3, status: 0, user_address: @add_3)
        @o6 = Order.create!(user: @user_3, status: 1, user_address: @add_3)
        @o7 = Order.create!(user: @user_3, status: 2, user_address: @add_3)
  
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_1)
      end

      it 'shows a disable enable button next to each merchant' do
        visit merchants_path

        within "#merchant-#{@m1.id}" do
          expect(page).to have_link(@m1.name)
          expect(page).to have_link("Disable")
        end
        within "#merchant-#{@m2.id}" do
          expect(page).to have_link(@m2.name)
          expect(page).to have_link("Enable")
        end
      end

      it 'can disable a merchant' do
        visit merchants_path

        within "#merchant-#{@m1.id}" do
          click_on("Disable")
        end

        expect(current_path).to eq(merchants_path)

        within("#flash-message") do
          expect(page).to have_content("Merchant's account is now disabled")
        end

        within "#merchant-#{@m1.id}" do
          expect(page).to have_link("Enable")
          expect(@m1.active).to eq(true)
        end
      end

      it 'can enable a merchant' do
        visit merchants_path

        within "#merchant-#{@m2.id}" do
          click_on("Enable")
        end

        expect(current_path).to eq(merchants_path)

        within("#flash-message") do
          expect(page).to have_content("Merchant's account is now enabled")
        end

        within "#merchant-#{@m2.id}" do
          expect(page).to have_link("Disable")
          expect(@m2.active).to eq(false)
        end
      end
    end
  end
end