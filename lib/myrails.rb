require 'thor'
require 'active_support/all'
require_relative "../lib/myrails/version"
require_relative 'myrails/modules/gems'
require_relative 'myrails/modules/bootstrap'
require_relative 'myrails/modules/material'
require_relative 'myrails/modules/ui'
require_relative 'myrails/modules/assets'
require_relative 'myrails/modules/application_generators'
require_relative 'myrails/modules/application_generator_actions'
require_relative 'myrails/modules/capistrano'
require_relative 'myrails/modules/database_generator'
require_relative 'myrails/modules/database_generator_actions'
require_relative 'myrails/modules/devise'
require_relative 'myrails/modules/dotenv'
require_relative 'myrails/modules/draper'
require_relative 'myrails/modules/engine_generators'
require_relative 'myrails/modules/engine_generator_actions'
require_relative 'myrails/modules/figaro'
require_relative 'myrails/modules/heroku'
require_relative 'myrails/modules/pundit'
require_relative 'myrails/modules/rails_generators'
require_relative 'myrails/modules/rails_generator_actions'
require_relative 'myrails/modules/rspec_generators'
require_relative 'myrails/modules/rspec_generator_actions'
require_relative 'myrails/modules/rspec'

module Myrails
  class Myrails < Thor
    include Thor::Actions
    
    source_root "#{__dir__}/myrails/templates"
    
    TEMPLATES = source_root

    no_tasks do
      include Install::Gems
      include Install::Ui
      include Install::RSpec
      include Install::Devise
      include Install::Pundit
      include Install::DotEnv
      include Install::Heroku
      include Install::Capistrano
      include Install::Assets
      include Install::Figaro
      include Install::Draper
      include Layout::Bootstrap
      include Layout::Material
      include Rails::Generator::Actions
      include RSpec::Generator::Actions
      include Engine::Generator::Actions
      include Database::Generator::Actions
      include Application::Generator::Actions
      
    end # end of no_tasks
    
    
    include Rails::Generators
    include RSpec::Generators
    include Engine::Generators
    include Database::Generators
    include Application::Generators
    
    # Moved here because it envokes draper kickstart method for some reason.
    # Will address later.
    desc 'setup_sendgrid', 'Generate sendgrid initializer and mail interceptor'
    def setup_sendgrid
      environments = %w(development test production)
  
      @email = ask 'What email address would you like to use?', :yellow
  
      raise ArgumentError, 'Email address required' unless @email
  
      copy_file 'rails/config/initializers/sendgrid.rb', 'config/initializers/sendgrid.rb'
      template 'rails/app/mailers/dev_mail_interceptor.rb', 'app/mailers/dev_mail_interceptor.rb'
      
      environments.each do |environment|
        unless environment == 'production'
          inject_into_file "config/environments/#{environment}.rb", after: "Rails.application.configure do\n" do <<-CODE
  ActionMailer::Base.register_interceptor(DevMailInterceptor)
            CODE
          end
        end
      end
    end
    
  end
end

Myrails::Myrails.start(ARGV)
