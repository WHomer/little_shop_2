class Default::UserAddressesController < Default::BaseController
  def destroy
    @address = UserAddress.find_by(id: params[:id])
    if @address.orders
      flash[:notice] = "#{@address.nickname} has orders and can't be removed."
    elsif @address.destroy
      flash[:notice] = "#{@address.nickname} has been removed."
    end
    redirect_to profile_path
  end

  def edit
    @user_address = UserAddress.find_by(id: params[:id])
  end

  def update
    user = current_user
    address = UserAddress.find_by(id: params[:id])
    address.update(address_params)
    flash[:notice] = "Address, #{address.nickname}, has been updated"
    redirect_to profile_path
  end

  def new
    @user_address = UserAddress.new
  end

  def create
    user = current_user
    address = user.user_addresses.create(address_params)
    flash[:notice] = "Address Added to Profile"
    redirect_to profile_path
  end


  private
  def address_params
    params.require(:user_address).permit(:nickname, :street_address_1, :street_address_2, :city, :state_province, :zip_code, :phone_number)
  end
end