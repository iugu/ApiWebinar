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

  def new_charge
  end

  def create_charge
    unless params[:token].present?
      #boleto
      @params = bank_slip_params
    else
      #cartão
      @params = credit_card_params
    end
    @params.merge!(default_params)
    @response = Iugu::Charge.create(@params)

    if @response.success
      @invoice = Iugu::Invoice.fetch(@response.invoice_id)
    end
  end

  private

  def credit_card_params
    {
      token: params[:token]
    }
  end

  def bank_slip_params
    {
      method: "bank_slip",
      bank_slip_extra_days: 2
    }
  end

  def default_params
    {
      customer_id: current_user.customer_id,
      items: [{
        description: "Item Um",
        quantity: "1",
        price_cents: "1000"
      },
      {
        description: "Item Dois",
        quantity: "1",
        price_cents: "500"
      }]
    }
  end

  def validation_error(errors)
    flash[:errors] = errors
    render :new
  end
  
end
