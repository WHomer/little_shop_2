class Default::UserAddressesController < Default::BaseController
  def destroy
    @address = UserAddress.find_by(id: params[:id])
    if @address.destroy
      flash[:notice] = "#{@address.nickname} has been removed."
    end
    redirect_to profile_path
  end
end