class Cart
  attr_reader :contents

  def initialize(session)
    @contents = session || Hash.new(0)
  end

  def add(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def ids_to_items
    items = {}
    self.contents.each do |item_id, qty|
      items[Item.find(item_id)] = qty
    end
    items
  end

  def total_price
    ids_to_items.sum{|item, qty| item.price * qty}
  end

  def create_order(buyer_id, address_id)
    order = Order.new(user_id: buyer_id, status: 1, user_address_id: address_id)
    ids_to_items.each do |item, qty|
      oi = OrderItem.new(item: item, order: order, quantity: qty, price: item.price, fulfilled: false )
      oi.save
    end
    # require 'pry'; binding.pry
    order.save
  end
end
