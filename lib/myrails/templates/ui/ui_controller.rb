# @author Lovell McIlwain
# Handles HTTP actions for UI
class UiController < ApplicationController
  # Before filter to check if application is running in development
   before_action do
    redirect_to :root if Rails.env.production?
  end
end
