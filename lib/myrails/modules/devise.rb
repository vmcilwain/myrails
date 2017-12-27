module Install
  module Devise
    def self.included(thor)
      thor.class_eval do

        def add_gem
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'devise'
CODE
          end
          run 'bundle update'
        end

        def add_rspec_config
          copy_file 'spec/support/configs/devise.rb', 'spec/support/configs/devise.rb'
        end

        def configure_devise
          devise_model = ask("What would you like to call the devise model? Default: user")
          devise_model = devise_model.empty? ? 'user' : devise_model
          run 'rails generate devise:install'
          run 'rake db:migrate'
          run "rails generate devise #{devise_model}"
          run 'rails generate devise:views'

          gsub_file 'app/controllers/application_controller.rb', "protect_from_forgery with: :exception", "protect_from_forgery"
          inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery\n" do <<-CODE
  # Devise authentication method
  before_action :authenticate_#{devise_model}!
  CODE
          end
        end

        def configure_ui_controller
          if File.exist?('app/controllers/ui_controller.rb')
            inject_into_file 'app/controllers/ui_controller.rb', after: "class UiController < ApplicationController\n" do <<-CODE
  skip_before_action :authenticate_#{devise_model}!
CODE
            end
          end
        end

        def add_additional_fields
          if yes?('Will you be needing registration params override? Answer "yes" if you will be adding attributes to the user model')
            inject_into_file 'app/controllers/application_controller.rb',  after: "before_action :authenticate_#{devise_model}!\n" do <<-CODE
    # Before action include additional registration params
    # (see #configure_permitted_parameters)
    before_action :configure_permitted_parameters, if: :devise_controller?
  CODE
            end

            inject_into_file 'app/controllers/application_controller.rb',  after: "private\n" do <<-CODE
    # Register additional registration params
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, :attribute])
    end
  CODE
            end
          end
        end

        def install_devise
          add_gem
          add_rspec_config
          configure_devise
          configure_ui_controller
          add_additional_fields
        end

      end
    end
  end
end
