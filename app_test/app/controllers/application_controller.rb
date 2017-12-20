class ApplicationController < ActionController::Base
  add_flash_types :error, :success
  protect_from_forgery with: :exception
  private
end
