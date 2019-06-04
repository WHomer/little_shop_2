class Default::OrdersController < Default::BaseController
  def update
    order = Order.find_by(id: params[:id])
    order.update(user_address_id: params[:address])
    flash[:notice] = "Order #{order.id} shipping address has been updated."
    
    redirect_to profile_order_path
  end

  def index
    @user = current_user
    @orders = @user.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  def destroy
    @order = Order.find(params[:id])
    @order.update(status: :cancelled)
    @order.order_items.each do |order_item|
      order_item.update(fulfilled: false)
    end
    flash[:notice] = "#{@order.id} has been cancelled."

    redirect_to profile_orders_path
  end

  def create
    cart = Cart.new(session[:cart])
    if cart.contents.empty?
      carts_path
    else
      cart.create_order(current_user.id, params[:format])
      session[:cart] = {}
      flash.notice = "Your Order Was Created"
      redirect_to profile_orders_path
    end
  end
end
