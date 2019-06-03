class UsersController < ApplicationController

  def new
    @user = User.new
    @user.user_addresses.new
  end

  def create
    @user = User.new(user_params)
    if password_confirmation != true
      flash.now[:notice] = "Those passwords don't match."
      render :new
    elsif @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are now registered and logged in."
      redirect_to profile_path
    else
      render :new
    end
  end

  private

  def password_confirmation
    if params["user"]["password"] == params["user"]["confirm_password"]
      true
    else
      false
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, user_addresses_attributes: [:nickname, :street_address_1, :street_address_2, :city, :state_province, :zip_code, :phone_number] )
  end

end
