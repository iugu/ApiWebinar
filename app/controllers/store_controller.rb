class StoreController < ApplicationController

  before_action :require_login
  before_action :prepare_api

  def index
    @response = @api.get("/invoices",{
      query: params[:query]
    })
    puts @response
    @invoices = @response[:body]["items"]
  end

  def create_invoice
    @response = @api.post('/invoices', {
      "email" => params[:email],
      "items[][description]" => params[:description],
      "items[][quantity]" => params[:quantity],
      "items[][price_cents]" => params[:price_cents],
      "due_date" => "2017-03-16",
      "payable_with" => "bank_slip"
    })
    redirect_to store_index_path(env: @env)
  end

  private

  def prepare_api
    @env = params[:env]
    @api_token = (@env == "test" ? current_user.api_test_token : current_user.api_live_token)
    @api = IuguApi.new(@api_token)
  end
  
end
