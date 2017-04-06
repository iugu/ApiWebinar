Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "landing#index"

  get "/checkout", to: "checkout#new", as: "checkout_new"
  post "/checkout", to: "checkout#create", as: "checkout_create"

  get "/checkout_boleto", to: "checkout#new_boleto", as: "checkout_boleto_new"
  post "/checkout_boleto", to: "checkout#create_boleto", as: "checkout_boleto_create"

  get "/checkout_charge", to: "checkout#new_charge", as: "checkout_charge_new"
  post "/checkout_charge", to: "checkout#create_charge", as: "checkout_charge_create"

  get "/registration", to: "registration#new", as: "registration_new"
  post "/registration", to: "registration#create", as: "registration_create"

  get "/login", to: "session#new", as: "session_new"
  post "/login", to: "session#create", as: "session_create"
  delete "/logout", to: "session#destroy", as: "session_destroy"

  get "/loja/:env", to: "store#index", as: "store_index"
  post "/loja/:env/create_invoice", to: "store#create_invoice", as: "store_create_invoice"

  get "/administracao_loja", to: "subaccount_administration#index", as: "index_subaccount"
  post "/administracao_loja/verificacao", to: "subaccount_administration#verify", as: "verify_subaccount"
  post "/administracao_loja/conta_bancaria", to: "subaccount_administration#change_bank_address", as: "change_bank_address_subaccount"
end
