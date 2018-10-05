module Install
  module Pundit
    def self.included(thor)
      thor.class_eval do

        desc 'add_pundit_gem', 'Add Pundit gem to Gemfile'
        def add_pundit_gem
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'pundit'
CODE
          end
        end
        
        
        desc 'add_pundit_matcher_gem', 'Add Pundit Matcher gfem to Gemfile'
        def add_pundit_matcher_gem
          insert_into_file 'Gemfile', after: "group :test do\n" do <<-CODE
  gem 'pundit-matchers'
CODE
          end
        end
        
        desc 'add_pundit_gems', 'Add pundit and pundit-matches to Gemfile and run bundler'
        def add_pundit_gems
          add_pundit_gem
          add_pundit_matcher_gem          
          run 'bundle update'
        end
        desc 'generate_pundit_files', 'Run pundit generator'
        def generate_pundit_files
          run 'rails g pundit:install'
        end

        desc 'include_pundit', 'Add Pundit to the application controller'
        def include_pundit
          inject_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-CODE
  # Add pundit authorization
  include Pundit
  # Rescue from pundit error
  # (see #user_not_authorized)
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
CODE
          end
        end
        
        desc 'add_pundit_rescue_notice', 'Add notice to gracefully rescue from Pundit error'
        def add_pundit_rescue_notice
          inject_into_file 'app/controllers/application_controller.rb', after: "private\n" do <<-CODE
  # Method to gracefully let a user know they are are not authorized
  #
  # @return flash [Hash] the action notice
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to root_path
  end
CODE
          end
        end
        
        def enable_pundit
          include_pundit
          add_pundit_rescue_notice
        end

        desc 'install_pundit', 'Install pundit gem and generate pundit files and application controller code'
        def install_pundit
          add_pundit_gems
          generate_pundit_files
          enable_pundit
        end

      end
    end
  end
end
