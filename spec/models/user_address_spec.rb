require 'rails_helper'

RSpec.describe UserAddress, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'validations' do
    it {should validate_presence_of :nickname}
    # it {should validate_presence_of :first_name}
    # it {should validate_presence_of :last_name}
    it {should validate_presence_of :street_address_1}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state_province}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :phone_number}
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
      @a1 = @user_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @a2 = @user_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @a3 = @user_3.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @order_1 = create(:order, user: @user_1, status: 2, user_address: @a1)
      @order_2 = create(:order, user: @user_2, status: 2, user_address: @a2)
      @order_3 = create(:order, user: @user_3, status: 1, user_address: @a3)
      @order_4 = create(:order, user: @user_3, status: 0, user_address: @a3)
      OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_2, order: @order_2, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_3, quantity: 12, price: 1.99, fulfilled: false)
      OrderItem.create!(item: @item_3, order: @order_4, quantity: 12, price: 1.99, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'user_address_orders' do
      expect(@a1.address_orders).to eq([@order_1])
      expect(@a2.address_orders).to eq([@order_2])
      expect(@a3.address_orders).to eq([])
    end
  end
end

