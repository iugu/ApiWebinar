class CheckoutController < ApplicationController
  layout "checkout"

  before_action :require_login

  def new_boleto
  end

  def create_boleto
    customer = Iugu::Customer.fetch(current_user.customer_id)

    subscription = Iugu::Subscription.create({
      "plan_identifier" => params[:plan], "customer_id" => customer.id, "payable_with" => "bank_slip"
    })

    return validation_error(subscription.errors) if subscription.errors

    render :create
  end

  def new
  end

  def create
    customer = Iugu::Customer.fetch(current_user.customer_id)

    payment_method = customer.payment_methods.create({
      description: "Cartão",
      token: params[:token]
    })

    return validation_error(payment_method.errors) if payment_method.errors

    subscription = Iugu::Subscription.create({
      "plan_identifier" => params[:plan], "customer_id" => customer.id
    })

    return validation_error(subscription.errors) if subscription.errors
  end

  private

  def validation_error(errors)
    flash[:errors] = errors
    render :new
  end
  
end
