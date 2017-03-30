class SubaccountAdministrationController < ApplicationController
  before_action :require_login
  before_action :prepare_api

  def verify
    @response = @api.post("accounts/#{current_user.iugu_account_id}/request_verification", {
      "automatic_validation"=> "true",
      "data[price_range]" => "",
      "data[physical_products]" => "",
      "data[business_type]" => "",
      "data[person_type]" => "Pessoa Jurídica",
      "data[automatic_transfer]" => "",
      "data[cnpj]" => "15.111.975/0001-64",
      "data[company_name]" => "",
      "data[address]" => "",
      "data[cep]" => "",
      "data[city]" => "",
      "data[state]" => "",
      "data[telephone]" => "",
      "data[resp_name]" => "",
      "data[resp_cpf]" => "",
      "data[bank]" => "Itaú",
      "data[bank_ag]" => "",
      "data[account_type]" => "Corrente",
      "data[bank_cc]" => ""
    })
  end

  def change_bank_address
    url = "https://d21fvzaqybvyws.cloudfront.net/9CA0F40E971643D1B7C8DE46BBC18396/images/30/30/52a4f0158b66582bc0df886178544375246dd3577d997.jpg"
    documento = "data:image/jpg;base64,#{Base64.encode64( open(url).read)}"
    @response = @api.post("/bank_verification", {
      "automatic_validation" => "true",
      "agency" => params[:agency],
      "account" => params[:account],
      "account_type" => params[:account_type],
      "bank" => params[:bank],
      "document" => documento
    })
  end

  private

  def prepare_api
    @env = params[:env]
    @api_token = current_user.api_live_token
    @api = IuguApi.new(@api_token)
  end
  
end
