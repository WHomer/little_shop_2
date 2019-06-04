class Order < ApplicationRecord
  belongs_to :user
  belongs_to :user_address
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def date_made
    created_at.strftime("%B %-d, %Y")
  end

  def last_updated
    updated_at.strftime("%B %-d, %Y")
  end

  def item_count
    items.count
  end

  def grand_total
    order_items.sum do |item|
      item.price * item.quantity
    end
  end

  def check_fulfillments
    if order_items.all? {|order_item| order_item.fulfilled}
      update(status: :packaged)
    end
  end
  
  def self.biggest_3
    self.joins(:items)
        .select('count(items.id), orders.*')
        .where('orders.status=2')
        .group(:id)
        .order(count: :desc)
        .limit(3)
  end
end
