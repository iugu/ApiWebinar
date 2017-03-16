class RegistrationController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      customer = Iugu::Customer.create({
        "email"=>@user.email,
        "name"=>@user.name
      })
      return render_errors(customer.errors) if customer.errors
      @user.customer_id = customer.id
      @user.save
      auto_login(@user)
    else
      return render_errors(@user.errors)
    end
    redirect_to checkout_new_path
  end

  private

  def render_errors(errors)
    flash.now[:errors] = errors
    render :new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
