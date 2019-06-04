require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :orders }
    it { should have_many :user_addresses }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password_digest }
    # it { should validate_presence_of :role }
    # it { should validate_presence_of :active }
    it { should validate_presence_of :name }
    # it { should validate_presence_of :address }
    # it { should validate_presence_of :city }
    # it { should validate_presence_of :state }
    # it { should validate_presence_of :zip }

    it { should validate_uniqueness_of :email }
  end

  describe 'class methods' do

    it 'email_string' do
      user_1 = User.create!(name: "default_user", role: 0, active: true, password_digest: "8320280282", email: "default_user@gmail.com" )
      user_2 = User.create!(name: "default_user1", role: 0, active: true, password_digest: "8320280282", email: "default_user1@gmail.com" )
      user_3 = User.create!(name: "default_user2", role: 0, active: true, password_digest: "8320280282", email: "default_user2@gmail.com" )

      expect(User.email_string).to include("default_user@gmail.com")
      expect(User.email_string).to include("default_user1@gmail.com")
      expect(User.email_string).to include("default_user2@gmail.com")
    end

    it '.all_active_merchants' do
      merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
      merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
      merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
      merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
      merchant_5 = create(:user, role: 1, active: false)
      merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)

      expect(User.all_active_merchants).to include(merchant_1)
      expect(User.all_active_merchants).to include(merchant_2)
      expect(User.all_active_merchants).to include(merchant_3)
      expect(User.all_active_merchants).to include(merchant_4)
      expect(User.all_active_merchants).to_not include(merchant_5)
      expect(User.all_active_merchants).to_not include(merchant_6)
      expect(User.all_active_merchants).to_not include(user)
    end

    it '.top_3_merchants_by_sales' do
      merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
      merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
      merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
      merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
      merchant_5 = create(:user, role: 1, active: false)
      merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)
      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_5)
      order_1 = create(:order, user: user, status: 2, user_address: address)
      order_2 = create(:order, user: user, status: 2, user_address: address)
      order_3 = create(:order, user: user, status: 2, user_address: address)
      order_4 = create(:order, user: user, status: 2, user_address: address)
      order_5 = create(:order, user: user, status: 1, user_address: address)
      order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + 30)
      order_item_2 = OrderItem.create!(item: item_2, order: order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + 40)
      order_item_3 = OrderItem.create!(item: item_3, order: order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + 50)
      order_item_4 = OrderItem.create!(item: item_4, order: order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + 60)
      order_item_5 = OrderItem.create!(item: item_1, order: order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + 80)
      order_item_6 = OrderItem.create!(item: item_2, order: order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + 90)
      order_item_7 = OrderItem.create!(item: item_3, order: order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + 100)
      order_item_8 = OrderItem.create!(item: item_1, order: order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + 110)
      order_item_9 = OrderItem.create!(item: item_2, order: order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + 120)
      order_item_10 = OrderItem.create!(item: item_1, order: order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + 130)
      order_item_10 = OrderItem.create!(item: item_5, order: order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_11 = OrderItem.create!(item: item_6, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)

      expect(User.top_3_merchants_by_sales[0]).to eq(merchant_1)
      expect(User.top_3_merchants_by_sales[1]).to eq(merchant_2)
      expect(User.top_3_merchants_by_sales[2]).to eq(merchant_3)
    end

    it '.fastest_fulfilling_merchants and .slowest_fulfilling_merchants' do
      
      merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
      merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
      merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
      merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
      merchant_5 = create(:user, role: 1, active: false)
      merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)
      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_5)
      order_1 = create(:order, user: user, status: 2, user_address: address)
      order_2 = create(:order, user: user, status: 2, user_address: address)
      order_3 = create(:order, user: user, status: 2, user_address: address)
      order_3 = create(:order, user: user, status: 2, user_address: address)
      order_4 = create(:order, user: user, status: 2, user_address: address)
      order_5 = create(:order, user: user, status: 1, user_address: address)
      order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + 30)
      order_item_2 = OrderItem.create!(item: item_2, order: order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + 40)
      order_item_3 = OrderItem.create!(item: item_3, order: order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + 50)
      order_item_4 = OrderItem.create!(item: item_4, order: order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + 60)
      order_item_5 = OrderItem.create!(item: item_1, order: order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + 80)
      order_item_6 = OrderItem.create!(item: item_2, order: order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + 90)
      order_item_7 = OrderItem.create!(item: item_3, order: order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + 100)
      order_item_8 = OrderItem.create!(item: item_1, order: order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + 110)
      order_item_9 = OrderItem.create!(item: item_2, order: order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + 120)
      order_item_10 = OrderItem.create!(item: item_1, order: order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + 130)
      order_item_10 = OrderItem.create!(item: item_5, order: order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_11 = OrderItem.create!(item: item_6, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)

      expect(User.fastest_3_fulfilling_merchants[0]).to eq(merchant_4)
      expect(User.fastest_3_fulfilling_merchants[1]).to eq(merchant_3)
      expect(User.fastest_3_fulfilling_merchants[2]).to eq(merchant_2)
      expect(User.fastest_3_fulfilling_merchants.length).to eq(3)

      expect(User.slowest_3_fulfilling_merchants[0]).to eq(merchant_1)
      expect(User.slowest_3_fulfilling_merchants[1]).to eq(merchant_2)
      expect(User.slowest_3_fulfilling_merchants[2]).to eq(merchant_3)
      expect(User.slowest_3_fulfilling_merchants.length).to eq(3)
    end

    it '.top_3_states' do
      merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
      merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
      merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
      merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
      merchant_5 = create(:user, role: 1, active: false)
      merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)
      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_5)
      order_1 = create(:order, user: user, status: 2, user_address: address)
      order_2 = create(:order, user: user, status: 2, user_address: address)
      order_3 = create(:order, user: user, status: 2, user_address: address)
      order_4 = create(:order, user: user, status: 2, user_address: address)
      order_5 = create(:order, user: user, status: 1, user_address: address)
      order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + 30)
      order_item_2 = OrderItem.create!(item: item_2, order: order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + 40)
      order_item_3 = OrderItem.create!(item: item_3, order: order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + 50)
      order_item_4 = OrderItem.create!(item: item_4, order: order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + 60)
      order_item_5 = OrderItem.create!(item: item_1, order: order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + 80)
      order_item_6 = OrderItem.create!(item: item_2, order: order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + 90)
      order_item_7 = OrderItem.create!(item: item_3, order: order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + 100)
      order_item_8 = OrderItem.create!(item: item_1, order: order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + 110)
      order_item_9 = OrderItem.create!(item: item_2, order: order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + 120)
      order_item_10 = OrderItem.create!(item: item_1, order: order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + 130)
      order_item_10 = OrderItem.create!(item: item_5, order: order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_11 = OrderItem.create!(item: item_6, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_12 = OrderItem.create!(item: item_5, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)

      expect(User.top_3_states[0].state_province).to eq("state 1")
      expect(User.top_3_states[0].total_ordered).to eq(11)
    end

    it '.top_3_cities' do
      merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3))
      merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8))
      merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10))
      merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21))
      merchant_5 = create(:user, role: 1, active: false)
      merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_2)
      item_3 = create(:item, user: merchant_3)
      item_4 = create(:item, user: merchant_4)
      item_5 = create(:item, user: merchant_1)
      item_6 = create(:item, user: merchant_5)
      order_1 = create(:order, user: user, status: 2, user_address: address)
      order_2 = create(:order, user: user, status: 2, user_address: address)
      order_3 = create(:order, user: user, status: 2, user_address: address)
      order_4 = create(:order, user: user, status: 2, user_address: address)
      order_5 = create(:order, user: user, status: 1, user_address: address)
      order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + 30)
      order_item_2 = OrderItem.create!(item: item_2, order: order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + 40)
      order_item_3 = OrderItem.create!(item: item_3, order: order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + 50)
      order_item_4 = OrderItem.create!(item: item_4, order: order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + 60)
      order_item_5 = OrderItem.create!(item: item_1, order: order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + 80)
      order_item_6 = OrderItem.create!(item: item_2, order: order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + 90)
      order_item_7 = OrderItem.create!(item: item_3, order: order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + 100)
      order_item_8 = OrderItem.create!(item: item_1, order: order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + 110)
      order_item_9 = OrderItem.create!(item: item_2, order: order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + 120)
      order_item_10 = OrderItem.create!(item: item_1, order: order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + 130)
      order_item_10 = OrderItem.create!(item: item_5, order: order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_11 = OrderItem.create!(item: item_6, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_12 = OrderItem.create!(item: item_5, order: order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)

      expect(User.top_3_cities[0].city).to eq("city 1")
      expect(User.top_3_cities[0].count).to eq(11)
      expect(User.top_3_cities.length).to eq(1)
    end

  end

  describe 'instance_methods' do

    before :each do
      @merchant = create(:user, role: 1)
      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)
      @item_4 = create(:item, user: @merchant)
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @order_1 = create(:order, user: @user_1, status: 1, user_address: address)
      @order_2 = create(:order, user: @user_2, status: 1, user_address: address)
      @order_3 = create(:order, user: @user_3, status: 0, user_address: address)
      @order_4 = create(:order, user: @user_3, status: 0, user_address: address)
      OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_2, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_3, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_4, quantity: 12, price: 1.99, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'pending_orders' do
      orders = [@order_1, @order_2]

      expect(@merchant.pending_orders).to eq(orders)
    end
  end

  describe 'instance_methods_us36' do

    before :each do
      @merchant = create(:user, name: 'merchant', role: 1)
      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)
      @item_4 = create(:item, user: @merchant)
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
      @user_4 = create(:user)
      @user_5 = create(:user)
      address = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'CO', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 2', state_province: 'CO', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 3', state_province: 'IL', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_4.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 4', state_province: 'IL', zip_code: '123123', phone_number: 'phone 1' )
      address = @user_5.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 5', state_province: 'MI', zip_code: '123123', phone_number: 'phone 1' )
      @order_1 = create(:order, user: @user_1, status: 2, user_address: address)
      @order_2 = create(:order, user: @user_2, status: 2, user_address: address)
      @order_3 = create(:order, user: @user_3, status: 2, user_address: address)
      @order_4 = create(:order, user: @user_4, status: 2, user_address: address)
      @order_5 = create(:order, user: @user_5, status: 2, user_address: address)
      @order_6 = create(:order, user: @user_3, status: 1, user_address: address)
      @order_7 = create(:order, user: @user_3, status: 0, user_address: address)
      OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_2, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_3, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_4, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_5, quantity: 500, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_6, quantity: 500, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_4, quantity: 500, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_3, quantity: 500, price: 1.99, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'top_items_sold(n)' do
      expect(@merchant.top_items_sold(1).first.id).to eq(@item_2.id)
      expect(@merchant.top_items_sold(2).first.id).to eq(@item_2.id)
      expect(@merchant.top_items_sold(2).last.id).to eq(@item_3.id)
    end

    it 'items_sold_percentage' do
      expect(@merchant.items_sold_percentage).to eq(1548 / 1948.to_f)
    end

    it 'items_sold' do
      expect(@merchant.items_sold).to eq(1548)
    end

    it 'total_items_count' do
      expect(@merchant.total_items_count).to eq(1948)
    end

    it '#top_3_states' do
      expect(@merchant.top_3_states.length).to eq(3)
      expect(@merchant.top_3_states[0].total_ordered).to eq(1024)
      expect(@merchant.top_3_states.first.state_province).to eq("IL")
      expect(@merchant.top_3_states.second.state_province).to eq("MI")
      expect(@merchant.top_3_states.third.state_province).to eq("CO")
    end

    it '#top_3_city_state' do
      expect(@merchant.top_3_city_state.length).to eq(1)
      expect(@merchant.top_3_city_state.first.total_ordered).to eq(1548)
      expect(@merchant.top_3_city_state.first.state_province).to eq("MI")
      expect(@merchant.top_3_city_state.first.city).to eq("city 5")
    end

    it '#best_customer_items' do
      expect(@merchant.best_customer_items.length).to eq(1)
      expect(@merchant.best_customer_items[0].user_id).to eq(@user_3.id)
      expect(@merchant.best_customer_items[0].total_bought).to eq(512)
    end

    it '#best_customer_orders' do
      user = create(:user)
      address = user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      order = create(:order, user: @user_2, status: 2, user_address: address)
      OrderItem.create!(item: @item_1, order: order, quantity: 12, price: 1.99, fulfilled: false)

      expect(@merchant.best_customer_orders.length).to eq(1)
      expect(@merchant.best_customer_orders[0].user).to eq(@user_2)
      expect(@merchant.best_customer_orders[0].order_count).to eq(2)
    end

    it '#top_users' do
      expect(@merchant.top_users[0].name).to eq(@user_3.name)
      expect(@merchant.top_users[1].name).to eq(@user_4.name)
      expect(@merchant.top_users[2].name).to eq(@user_5.name)
    end
  end
end
