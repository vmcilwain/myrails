module Install
  module Pundit
    def self.included(thor)
      thor.class_eval do

        desc 'install_pundit', 'Install pundit gem and generate pundit files and application controller code'
        def install_pundit
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'pundit'
          CODE
          end

          insert_into_file 'Gemfile', after: "group :test do\n" do <<-CODE
    gem 'pundit-matchers', '~> 1.1.0'
  CODE
          end

          run 'bundle update'
          run 'rails g pundit:install'

          inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-CODE
    # Add pundit authorization
    include Pundit
  CODE
          end

          inject_into_file 'app/controllers/application_controller.rb', after: "rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized\n" do <<-CODE
    # Rescue from pundit error
    # (see #user_not_authorized)
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  CODE
          end

          inject_into_file 'app/controllers/application_controller.rb', after: "private\n" do <<-CODE
    # Method to gracefully let a user know they are are not authorized
    #
    # @return flash [Hash] the action notice
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to home_path
    end
  CODE
          end
        end

      end
    end
  end
end
