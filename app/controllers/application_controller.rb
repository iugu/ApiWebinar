class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private 

  def not_authenticated
      redirect_to session_new_path, alert: "Please login first"
  end
end
