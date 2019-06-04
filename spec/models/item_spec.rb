require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :price}
    it { should validate_presence_of :description}
    it { should validate_presence_of :image}
    it { should validate_presence_of :inventory}
  end

  before :each do
    merchant_1 = create(:user)
    merchant_2 = create(:user)
    @item_1 = create(:item, user: merchant_1)
    @item_2 = create(:item, user: merchant_1)
    @item_3 = create(:item, user: merchant_1)
    @item_4 = create(:item, user: merchant_2)
    @item_5 = create(:item, user: merchant_2, active: false)
    @item_6 = create(:item, user: merchant_2, active: false)
    buyer_1 = create(:user)
    buyer_2 = create(:user)
    buyer_3 = create(:user)
    buyer_4 = create(:user)
    address = buyer_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
    order_1 = create(:order, user: buyer_1, user_address: address)
    order_2 = create(:order, user: buyer_1, user_address: address)
    order_3 = create(:order, user: buyer_2, user_address: address)
    order_4 = create(:order, user: buyer_2, user_address: address)
    order_5 = create(:order, user: buyer_3, user_address: address)
    order_6 = create(:order, user: buyer_3, user_address: address)
    order_7 = create(:order, user: buyer_3, user_address: address)
    order_8 = create(:order, user: buyer_2, user_address: address)
    order_9 = create(:order, user: buyer_1, user_address: address)
    order_10 = create(:order, user: buyer_3, user_address: address)
    order_11 = create(:order, user: buyer_4, user_address: address)
    @order_item_1 = OrderItem.create!(item: @item_1, order: order_1, quantity: 12, price: 1.99, fulfilled: true, created_at: 4.days.ago, updated_at: 1.days.ago)
    @order_item_2 = OrderItem.create!(item: @item_2, order: order_2, quantity: 3, price: 6.99, fulfilled: true, created_at: 3.days.ago, updated_at: 1.days.ago)
    @order_item_3 = OrderItem.create!(item: @item_3, order: order_3, quantity: 6, price: 11.99, fulfilled: true, created_at: 3.days.ago, updated_at: 1.days.ago)
    @order_item_4 = OrderItem.create!(item: @item_4, order: order_4, quantity: 7, price: 12.99, fulfilled: true, created_at: 7.days.ago, updated_at: 1.days.ago)
    @order_item_5 = OrderItem.create!(item: @item_5, order: order_5, quantity: 14, price: 13.99, fulfilled: true, created_at: 10.days.ago, updated_at: 1.days.ago)
    @order_item_6 = OrderItem.create!(item: @item_6, order: order_6, quantity: 5, price: 2.99, fulfilled: true, created_at: 1.days.ago, updated_at: 1.days.ago)
    @order_item_7 = OrderItem.create!(item: @item_1, order: order_7, quantity: 21, price: 9.99, fulfilled: true, created_at: 2.days.ago, updated_at: 1.days.ago)
    @order_item_8 = OrderItem.create!(item: @item_2, order: order_8, quantity: 31, price: 7.99, fulfilled: true, created_at: 4.days.ago, updated_at: 1.days.ago)
    @order_item_9 = OrderItem.create!(item: @item_3, order: order_9, quantity: 2, price: 12.99, fulfilled: false, created_at: 5.days.ago, updated_at: 1.days.ago)
    @order_item_10 = OrderItem.create!(item: @item_4, order: order_10, quantity: 3, price: 11.99, fulfilled: false, created_at: 8.days.ago, updated_at: 1.days.ago)
    @order_item_11 = OrderItem.create!(item: @item_5, order: order_11, quantity: 1, price: 21.99, fulfilled: false, created_at: 9.days.ago, updated_at: 1.days.ago)
    @order_item_12 = OrderItem.create!(item: @item_1, order: order_11, quantity: 1, price: 21.99, fulfilled: false, created_at: 9.days.ago, updated_at: 1.days.ago)
  end

  describe 'class methods' do

    it '.all_active' do
      active = [@item_1, @item_2, @item_3, @item_4]
      non_active = [@item_5, @item_6]

      Item.all_active.each do |item|
        expect(active.include?(item)).to be true
        expect(non_active.include?(item)).to be false
      end

    end

    it '.most_5_bought' do
      expect(Item.most_5_bought[0]).to eq(@item_2)
      expect(Item.most_5_bought[1]).to eq(@item_1)
      expect(Item.most_5_bought[2]).to eq(@item_5)
      expect(Item.most_5_bought[3]).to eq(@item_4)
      expect(Item.most_5_bought[4]).to eq(@item_3)
      expect(Item.most_5_bought.length).to eq(5)
    end

    it '.least_5_bought' do
      expect(Item.least_5_bought[0]).to eq(@item_6)
      expect(Item.least_5_bought[1]).to eq(@item_3)
      expect(Item.least_5_bought[2]).to eq(@item_4)
      expect(Item.least_5_bought[3]).to eq(@item_5)
      expect(Item.least_5_bought[4]).to eq(@item_1)
      expect(Item.least_5_bought.length).to eq(5)
    end

    it '.average_days_to_fulfill' do
      item1_average_days = ((@order_item_7.updated_at - @order_item_7.created_at)+(@order_item_1.updated_at - @order_item_1.created_at))/2 /60 /60 /24

      expect(@item_1.average_days_to_fulfill.round).to eq(item1_average_days.round)
    end
  end

end
