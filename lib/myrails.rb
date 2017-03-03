require 'thor'
require 'active_support/all'
require_relative "../lib/myrails/version"

module Myrails
  class Myrails < Thor
    include Thor::Actions
    source_root "#{__dir__}/myrails/templates"
    TEMPLATES = source_root
    ENVIRONMENTS = %w(development test production)

    desc 'model', 'Generates and empty rails model with the given name and its related spec file Use --namespace=namespace to create a namespaced model'
    option :name, required: true
    option :namespace
    def model
      if options[:namespace]
        template 'rails/namespace_model.rb', "app/models/#{options[:namespace]}/#{options[:name]}.rb"
        template 'rspec/namespace_model.rb', "spec/models/#{options[:namespace]}/#{options[:name]}_spec.rb"
      else
        template 'rails/model.rb', "app/models/#{options[:name]}.rb"
        template 'rspec/model.rb', "spec/models/#{options[:name]}_spec.rb"
      end
    end

    desc 'controller', 'Generate a rails controller with the given name along with boiler plate code and related spec file. Add --namespace=NAME to create a namespaced controller'
    option :name, required: true
    option :namespace
    def controller
      if options[:namespace]
        template 'rails/namespace_controller.rb', "app/controllers/#{options[:namespace]}/#{options[:name].pluralize}_controller.rb"
        template 'rails/parent_namespace_controller.rb', "app/controllers/#{options[:namespace]}/#{options[:namespace]}_controller.rb"
        template 'rspec/namespace_controller.rb', "spec/controllers/#{options[:namespace]}/#{options[:name].pluralize}_controller_spec.rb"
        run "mkdir -p app/views/#{options[:namespace]}/#{options[:name].pluralize}"
      else
        template 'rails/controller.rb', "app/controllers/#{options[:name].pluralize}_controller.rb"
        template 'rspec/controller.rb', "spec/controllers/#{options[:name].pluralize}_controller_spec.rb"
        run "mkdir -p app/views/#{options[:name].pluralize}"
      end
    end

    desc 'policy', 'Generate a pundit policy with the given name and a related spec file'
    option :name, required: true
    def policy
      template 'rails/pundit.rb', "app/policies/#{options[:name]}_policy.rb"
      template 'rspec/pundit.rb', "spec/policies/#{options[:name]}_policy_spec.rb"
    end

    desc 'presenter', 'Generate a presenter class with the given name and a related spec file'
    option :name, required: true
    def presenters
      copy_file 'presenters/base.rb', 'app/presenters/base_presenter.rb'
      template 'presenters/presenter.rb', "app/presenters/#{options[:name]}_presenter.rb"
      copy_file 'presenters/presenter_config.rb', 'spec/support/configs/presenter.rb'
      template 'presenters/presenter_spec.rb', "spec/presenters/#{options[:name]}_presenter_spec.rb"
    end

    desc 'factory', 'Generate a factory_girl file for use with rspec'
    option :name, required: true
    def factory
      template 'rspec/factory.rb', "spec/factories/#{options[:name]}.rb"
    end

    desc 'install_application_helper', 'Replace current application helper with one that has commonly used code'
    def install_application_helper
      copy_file 'rails/application_helper.rb', 'app/helpers/application_helper.rb'
    end

    desc 'install_ui', 'Generate UI files and code for prototyping views in app/views/ui'
    def install_ui
      copy_file 'ui/ui_controller.rb', 'app/controllers/ui_controller.rb'
      copy_file 'ui/index.html.haml', 'app/views/ui/index.html.haml'
      inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-CODE
        # Requires an application restart everytime a new page is added.
        Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
          action = File.basename(file,'.html.haml')
          get \"ui/\#{action}\", controller: 'ui', action: action
        end
        CODE
      end
    end

    desc 'install_rspec', 'Generate rspec structure & rspec configuration that I commonly use'
    def install_rspec
      insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'rspec-rails', group: :test
      CODE
      end
      run 'bundle install'
      run 'rails g rspec:install'
      copy_file 'rspec/database_cleaner.rb', "spec/support/configs/database_cleaner.rb"
      copy_file 'rspec/factory_girl.rb', 'spec/support/configs/factory_girl.rb'
      copy_file 'rspec/shoulda_matchers.rb', 'spec/support/configs/shoulda_matchers.rb'
      copy_file 'rspec/silence_backtrace.rb', 'spec/support/configs/silence_rspec_backtrace.rb'
      copy_file 'rspec/javascript.rb', 'spec/support/configs/javascript.rb'
      copy_file 'rspec/mailer.rb', 'spec/support/configs/mailer.rb'
      copy_file 'rspec/router.rb', 'spec/support/configs/router.rb'
      copy_file 'rspec/files.rb', 'spec/support/configs/files.rb'
    end

    desc 'install_mailer', 'Generate sendgrid initializer and mail interceptor'
    option :email, required: true
    def install_mailer
      copy_file 'mailer/sendgrid.rb', 'config/initializers/sendgrid.rb'
      template 'mailer/dev_mail_interceptor.rb', 'app/mailers/dev_mail_interceptor.rb'
      ENVIRONMENTS.each do |environment|
        unless environment == 'production'
          inject_into_file "config/environments/#{environment}.rb", after: "# config.action_view.raise_on_missing_translations = true\n" do <<-CODE
    ActionMailer::Base.register_interceptor(DevMailInterceptor)
            CODE
          end
        end
      end
    end

    desc 'config_env', 'Add code to environment files. Host refers to url options. Name option referes to controller and mailer default_url_options'
    option :name, required: true
    def config_env
      ENVIRONMENTS.each do |environment|
        if options[:name].nil?
          say "Missing parameter: --name"
        else
          case environment
          when 'development'
            inject_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false\n" do <<-CODE
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = false
      config.action_mailer.default_url_options = { host: 'http://#{options[:name]}.dev' }
      config.action_controller.default_url_options = { host: 'http://#{options[:name]}.dev' }
          CODE
            end
          when 'test'
            inject_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test\n" do <<-CODE
      config.action_mailer.default_url_options = { host: 'http://localhost:3000' }
      config.action_controller.default_url_options = { host: 'http://localhost:3000' }
          CODE
            end
          when 'production'
            inject_into_file 'config/environments/production.rb', after: "config.active_record.dump_schema_after_migration = false\n" do <<-CODE
      config.action_mailer.default_url_options = { host: '' }
      config.action_controller.default_url_options = { host: '' }
      config.assets.compile = true
          CODE
            end
          end
        end
      end
    end

    desc 'install_rails_helper', 'Add code to rspec/rails_helper so rspec runs the way I like'
    def install_rails_helper
      inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'\n" do <<-CODE
  require 'simplecov'
  SimpleCov.start
  #use Chromedriver
  unless ENV['NOCHROME']
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end
    CODE
      end

      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }", "Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }"

      gsub_file "spec/rails_helper.rb", "config.use_transactional_fixtures = true", "config.use_transactional_fixtures = false"

      inject_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do <<-CODE
    config.include(JavascriptHelper, type: :feature)
    CODE
      end
    end

    desc 'install_devise', 'Generate devise files'
    def install_devise
      insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
    gem 'devise', '~> 4.2.0'
      CODE
      end
      run 'bundle update'
      copy_file 'rspec/devise.rb', 'spec/support/configs/devise.rb'

      devise_model = ask("What would you like to call the devise model? Default: user")
      devise_model = devise_model.empty? ? 'user' : devise_model
      run 'rails generate devise:install'
      run 'rake db:migrate'
      run "rails generate devise #{devise_model}"
      run 'rails generate devise:views'

      inject_into_file 'app/controllers/application_controller.rb', before: 'protect_from_forgery with: :exception' do <<-CODE
    # Devise authentication method
    before_action :authenticate_#{devise_model}!
      CODE
      end

      if File.exist?('app/controllers/ui_controller.rb')
        inject_into_file 'app/controllers/ui_controller.rb', after: "class UiController < ApplicationController\n" do <<-CODE
    skip_before_action :authenticate_#{devise_model}!
        CODE
        end
      end

      if yes?('Will you be needing registration params override? Answer "yes" if you will be adding attributes to the user model')
        inject_into_file 'app/controllers/application_controller.rb',  after: "skip_before_action :authenticate_#{devise_model}!\n" do <<-CODE
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

    desc 'install_pundit', 'Install pundit gem and generate pundit files and application controller code'
    def install_pundit
      insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
    gem 'pundit'
      CODE
      end

      insert_into_file 'Gemfile', before: "group :development, :test do" do <<-CODE
    gem 'pundit-matchers', '~> 1.1.0'
      CODE
      end

      run 'bundle update'
      run 'rails g pundit:install'

      inject_into_file 'app/controllers/application_controller.rb', before: '# Prevent CSRF attacks by raising an exception.' do <<-CODE
    # Add pundit authorization
    include Pundit
      CODE
      end

      inject_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do <<-CODE
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

    desc 'install_footnotes', 'Install rails-footnotes and run its generator'
    def install_footnotes
      insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
    gem 'rails-footnotes'
      CODE
      end
      run 'bundle install'
      run 'rails generate rails_footnotes:install'
    end

    desc 'install_gems', 'Add & Install gems that I commonly use'
    def install_gems
      insert_into_file 'Gemfile', before: "group :development, :test do" do <<-CODE
  group :test do
    gem 'simplecov'
    gem 'shoulda-matchers'
    gem 'factory_girl_rails'
    gem 'database_cleaner'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'chromedriver-helper'
    gem 'launchy'
    gem 'rails-controller-testing'
  end

    CODE
    end

    insert_into_file 'Gemfile', after: "group :development, :test do\n" do <<-CODE
    gem 'faker'
    gem 'yard'
    gem 'letter_opener'
    gem "rails-erd"
    CODE
    end

    insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'node'
  gem 'bootstrap-sass', '~> 3.3.1'
  gem 'autoprefixer-rails'
  gem 'haml-rails'
  gem "ransack"
  gem 'will_paginate'
  gem "font-awesome-rails"
  gem 'trix'
  gem 'record_tag_helper'
      CODE
      end
      run 'bundle install'

      insert_into_file 'app/controllers/application_controller.rb', before: 'end' do <<-CODE
    private
        CODE
      end
    end

    desc 'install_assets', 'Generate common asset pipeline files'
    def install_assets
      run "rm app/assets/stylesheets/application.css"
      copy_file 'assets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
      copy_file 'assets/application.js', 'app/assets/javascripts/application.js'
      copy_file 'assets/animate.scss', 'app/assets/stylesheets/animate.scss'
      copy_file 'assets/will_paginate.scss', 'app/assets/stylesheets/will_paginate.scss'
    end


    desc 'install_css', 'Generate & include application css theme'
    def install_css
      themes = Dir[File.join(TEMPLATES, 'assets', 'bootstrap_themes', '*')]

      themes.each_with_index do |theme, index|
        say "[#{index}] #{File.basename(theme,'.*')}"
      end

      idx = ask("Choose a color theme (by number) for the application. Default: 'spacelab'")
      idx = idx.empty? ? themes.index{|theme| theme if theme.include?('spacelab')} : idx.to_i
      copy_file(themes[idx], "app/assets/stylesheets/#{File.basename(themes[idx])}")

      inject_into_file 'app/assets/stylesheets/application.css.sass', before: "@import will_paginate" do <<-CODE
@import #{File.basename(themes[idx], '.*')}
        CODE
      end
    end

    desc 'install_footer', 'Generate & include application footer'
    def install_footer
      footers = Dir[File.join(TEMPLATES, 'layout', 'footers', '*.haml')]
      footers_css = Dir[File.join(TEMPLATES, 'layout', 'footers', 'css', '*')]

      footers.each_with_index do |footer, index|
        say "[#{index}] #{File.basename(footer,'.html.*')}"
      end

      idx = ask("Chose a footer theme (by number) for the application. Deault: 'footer-distributed (Basic)'")
      idx = idx.empty? ? footers.index{|footer| footer if footer.include?('footer-distributed.html.haml')} : idx.to_i
      copy_file footers[idx], "app/views/layouts/_footer.html.haml"
      copy_file footers_css[idx], "app/assets/stylesheets/#{File.basename(footers_css[idx])}"

      inject_into_file 'app/assets/stylesheets/application.css.sass', after: "@import animate\n" do <<-CODE
  @import #{File.basename(footers_css[idx], '.*')}
        CODE
      end
    end

    desc 'install_layout', 'Generate common layout files'
    def install_layout
      run 'rm app/views/layouts/application.html.erb'
      template 'layout/application.html.haml', 'app/views/layouts/application.html.haml'
      template 'layout/_nav.html.haml', 'app/views/layouts/_nav.html.haml'
      copy_file 'layout/_info_messages.html.haml', 'app/views/layouts/_info_messages.html.haml'
      copy_file 'layout/_success_message.html.haml', 'app/views/layouts/_success_message.html.haml'
      copy_file 'layout/_error_messages.html.haml', 'app/views/layouts/_error_messages.html.haml'
    end

    desc 'install_heroku', 'setup application for use with heroku using sqlite3 for development'
    def install_heroku
      insert_into_file 'Gemfile', before: "group :development, :test do\n" do <<-CODE
  group :production do
    gem 'pg'
    gem 'rails_12factor'
  end

        CODE
        end
        copy_file 'db/sqlite3_database.yml', 'config/database.yml'
        copy_file 'heroku/Procfile', 'Procfile'
        copy_file 'heroku/puma.rb', 'config/puma.rb'
    end

    desc 'git_init', "Initialize git with some files autormoatically ignored"
    def git_init
      run 'git init'
      run 'echo /coverage >> .gitignore'
      run 'echo /config/application.yml >> .gitignore'
      run 'git add --all'
      run "git commit -m 'initial commit'"
    end

    desc 'mysql_switch', 'Switch to mysql database'
    def mysql_switch
      gsub_file 'Gemfile', "gem 'sqlite3'", "gem 'mysql2', '>= 0.3.13', '< 0.5'"
      run 'bundle install'
      copy_file 'db/mysql_database.yml', 'config/database.yml'
    end

    desc 'new_ui NAME', 'Create a new ui view'
    def new_ui(name)
      run "touch app/views/ui/#{name}.html.haml"
      say "DON'T FORGET: Restart Powify App"
    end

    desc 'engine(full | mountable)', 'Generate a full or mountable engine. default: mountable'
    option :name, required: true
    def engine(etype='mountable')
      run "rails plugin new #{options[:name]} --dummy-path=spec/dummy --skip-test-unit --#{etype}"
    end

    desc 'engine_setup', 'Configure rails engine for development with RSpec, Capybara and FactoryGirl'
    option :name, required: true
    def engine_setup
      gsub_file "#{options[:name]}.gemspec", 's.homepage    = "TODO"', 's.homepage    = "http://TBD.com"'

      gsub_file "#{options[:name]}.gemspec", "s.summary     = \"TODO: Summary of #{options[:name].camelize}.\"", "s.summary     = \"Summary of #{options[:name].camelize}.\""

      gsub_file "#{options[:name]}.gemspec", "s.description = \"TODO: Description of #{options[:name].camelize}.\"", "s.description = \"Description of #{options[:name].camelize}.\""

      inject_into_file "#{options[:name]}.gemspec", after: "s.license     = \"MIT\"\n" do <<-CODE
  s.test_files = Dir["spec/**/*"]
        CODE
      end

      inject_into_file "#{options[:name]}.gemspec", after: "s.add_development_dependency \"sqlite3\"\n" do <<-CODE
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency  "faker"
  s.add_development_dependency  "byebug"
  s.add_development_dependency  'rails-controller-testing'
  s.add_development_dependency  'pundit-matchers'
  s.add_development_dependency  "simplecov"
  s.add_development_dependency  "shoulda-matchers"
  s.add_development_dependency  "database_cleaner"
  s.add_dependency 'pundit'
  s.add_dependency 'bootstrap-sass', '~> 3.3.6'
  s.add_dependency 'autoprefixer-rails'
  s.add_dependency "haml-rails"
  s.add_dependency "font-awesome-rails"
  s.add_dependency 'record_tag_helper'
        CODE
      end

      run 'bundle'
      copy_file 'rspec/database_cleaner.rb', 'spec/configs/database_cleaner.rb'
      copy_file 'rspec/factory_girl.rb', 'spec/configs/factory_gir.rb'
      copy_file 'rspec/presenter.rb', 'spec/configs/presenter.rb'
      copy_file 'rspec/shoulda_matchers', 'spec/configs/shoulda_matchers.rb'
      copy_file 'engines/rakefile', 'Rakefile'
      run 'rails g rspec:install'

      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }", "Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }"

      gsub_file 'spec/rails_helper.rb', "require File.expand_path('../../config/environment', __FILE__)", "require_relative 'dummy/config/environment'"

      inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do <<-CODE
require 'shoulda/matchers'
require 'factory_girl'
require 'database_cleaner'
        CODE
      end
      inject_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do <<-CODE
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
      CODE
      end

      inject_into_file "lib/#{options[:name]}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-CODE
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
        CODE
      end
    end

  end
end

Myrails::Myrails.start(ARGV)
