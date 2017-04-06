class RegistrationController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      return render_errors unless create_iugu_customer
      #return render_errors unless create_iugu_subaccount
      @user.save
      auto_login(@user)
    else
      return render_errors(@user.errors)
    end
    redirect_to checkout_new_path
    #redirect_to store_index_path(env: "test")
  end

  private

  def create_iugu_customer
    customer = Iugu::Customer.create({
      "email"=>@user.email,
      "name"=>@user.name
    })
    success = !customer.errors
    if success
      @user.customer_id = customer.id
    else
      @errors = customer.errors 
    end
    success
  end

  def create_iugu_subaccount
    api = IuguApi.new(IuguMasterApiToken)
    resp = api.post('/marketplace/create_account', {
      "name" => @user.name,
      "commission_percent" => 10
    })
    if success = resp[:success]
      body = resp[:body]
      @user.iugu_account_id = body["account_id"]
      @user.api_live_token = body["live_api_token"]
      @user.api_test_token = body["test_api_token"]
      @user.api_user_token = body["user_api_token"]
    else
      @errors = resp[:body]["errors"]
    end
    success
  end

  def render_errors
    flash.now[:errors] = @errors
    render :new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
