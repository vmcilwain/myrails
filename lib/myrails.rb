require 'thor'
require 'active_support/all'
require_relative "../lib/myrails/version"

module Myrails
  class Myrails < Thor
    include Thor::Actions
    source_root "#{__dir__}/myrails/templates"
    TEMPLATES = source_root
    ENVIRONMENTS = %w(development test production)

    no_tasks do
      desc 'install_application_helper', 'Replace current application helper with one that has commonly used code'
      def install_application_helper
        copy_file 'rails/app/helpers/application_helper.rb', 'app/helpers/application_helper.rb'
      end

      desc 'install_gems', 'Add & Install gems that I commonly use'
      def install_gems
        insert_into_file 'Gemfile', before: "group :development, :test do" do <<-CODE
group :test do
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
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
gem 'haml-rails'
gem "ransack"
gem 'will_paginate'
gem "font-awesome-rails"
gem 'trix'
gem 'record_tag_helper'
gem 'jquery-rails'
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
        copy_file 'rails/app/assets/stylesheets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
        copy_file 'rails/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
        copy_file 'rails/app/assets/stylesheets/animate.scss', 'app/assets/stylesheets/animate.scss'
        copy_file 'rails/app/assets/stylesheets/will_paginate.scss', 'app/assets/stylesheets/will_paginate.scss'
      end


      def choose_bootstrap_theme
        themes = Dir[File.join(TEMPLATES, 'rails', 'app','assets', 'stylesheets', 'bootstrap', 'bootstrap_themes', '*')]

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
      
      def choose_bootstrap_footer
        footers = Dir[File.join(TEMPLATES, 'rails', 'app', 'views','layout', 'bootstrap', 'footers', '*.haml')]
        footers_css = Dir[File.join(TEMPLATES, 'rails', 'app', 'views', 'layout', 'bootstrap', 'footers', 'css', '*')]

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
      
      def copy_bootstrap_files
        template 'rails/app/views/layout/bootstrap/application.html.haml', 'app/views/layouts/application.html.haml'
        template 'rails/app/views/layout/bootstrap/_nav.html.haml', 'app/views/layouts/_nav.html.haml'
        copy_file 'rails/app/views/layout/bootstrap/_info_messages.html.haml', 'app/views/layouts/_info_messages.html.haml'
        copy_file 'rails/app/views/layout/bootstrap/_success_message.html.haml', 'app/views/layouts/_success_message.html.haml'
        copy_file 'rails/app/views/layout/bootstrap/_error_messages.html.haml', 'app/views/layouts/_error_messages.html.haml'
        # copy_file 'rails/app/views/layout/bootstrap/_footer.html.haml', 'app/views/layouts/_footer.html.haml'
      end
      
      desc 'install_bootstrap', 'Generate Bootrap css theme'
      def install_bootstrap
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
CODE
        end
        
        insert_into_file 'app/assets/stylesheets/application.css.sass', before: '@import trix' do <<-CODE
@import bootstrap-sprockets
@import bootstrap
CODE
        end
        
        insert_into_file 'app/assets/javascripts/application.js', before: '//= require trix' do <<-CODE
//= require bootstrap-sprockets
CODE
        end
        run 'bundle install'
        choose_bootstrap_theme
        choose_bootstrap_footer
        copy_bootstrap_files
        
      end
      
      def copy_material_files
        Dir["#{__dir__}/myrails/templates/rails/app/views/layout/material/**/*"].each do |file|
          copy_file file, "app/views/layouts/#{File.basename(file)}"
        end
      end
      
      desc 'install_material', 'Generate Material css theme'
      def install_material
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'materialize-sass'
  gem 'material_icons'
  CODE
        end
        
        run 'bundle install'

        copy_material_files
        
        insert_into_file 'app/assets/stylesheets/application.css.sass', before: '@import trix' do <<-CODE
@import "materialize/components/color"
$primary-color: color("grey", "darken-3") !default
$secondary-color: color("grey", "base") !default
@import materialize
@import material_icons
CODE
        end
      
        insert_into_file 'app/assets/javascripts/application.js', before: "//= require trix" do <<-CODE
//= require materialize
CODE
        end
      end

      desc 'install_layout', 'Generate common layout files'
      def install_layout
        answer = ask 'Would you like to use [B]ootstrap or [M]aterial'
        
        run 'rm app/views/layouts/application.html.erb'
        
        install_assets
        
        if answer =~ /^B|b/
          install_bootstrap
        elsif answer =~ /^M|m/
          install_material
        end
        
        insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-CODE
  add_flash_types :error, :success
CODE
        end
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

      desc 'git_init', "Initialize git with some files automatically ignored"
      def git_init
        run 'git init'
        run 'echo /coverage >> .gitignore'
        run 'echo /config/application.yml >> .gitignore'
        run 'git add --all'
        run "git commit -m 'initial commit'"
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

        install_rails_helper

        Dir["#{__dir__}/myrails/templates/spec/**/*"].each do |file|
          if file.include?('/support/') && !['devise'].include?(File.basename(file, '.rb'))
            copy_file file, "#{file.gsub(__dir__+'/myrails/templates/', '')}" unless File.directory? file
          end
        end
      end

      desc 'install_rails_helper', 'Add code to rspec/rails_helper so rspec runs the way I like'
      def install_rails_helper
        inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'\n" do <<-CODE
require 'simplecov'
SimpleCov.start

Capybara.app_host = "http://localhost:3000"
Capybara.server_host = "localhost"
Capybara.server_port = "3000"

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
  # Can use methods like dom_id in features
  config.include ActionView::RecordIdentifier, type: :feature
  # Can use methods likke strip_tags in features
  config.include ActionView::Helpers::SanitizeHelper, type: :feature
  # Can use methods like truncate
  config.include ActionView::Helpers::TextHelper, type: :feature
  config.include(JavascriptHelper, type: :feature)
  config.include MailerHelper
CODE
        end
      end

      desc 'install_devise', 'Generate devise files'
      def install_devise
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'devise'
CODE
        end
        run 'bundle update'
        copy_file 'spec/support/configs/devise.rb', 'spec/support/configs/devise.rb'

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

        if File.exist?('app/controllers/ui_controller.rb')
          inject_into_file 'app/controllers/ui_controller.rb', after: "class UiController < ApplicationController\n" do <<-CODE
  skip_before_action :authenticate_#{devise_model}!
CODE
          end
        end

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

      desc 'install_footnotes', 'Install rails-footnotes and run its generator'
      def install_footnotes
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'rails-footnotes'
CODE
        end
        run 'bundle install'
        run 'rails generate rails_footnotes:install'
      end

      desc 'install_dotenv', 'Install dotenv gem'
      def install_dotenv
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'dotenv-rails', groups: [:development, :test]
CODE
        end

        run 'bundle install'

        inject_into_file 'config.ru', after: "require_relative 'config/environment'\n" do <<-CODE
require 'dotenv'
Dotenv.load
CODE
        end
        copy_file 'rails/env.config', '.env.development'
        copy_file 'rails/env.config', '.env.test'
        run 'touch .env.production'
      end

      desc 'base_install', 'Run the most common actions in the right order'
      def base_install
        install_gems
        install_application_helper
        install_assets
        install_layout
        install_css
        install_footer
        install_ui
        install_pundit
        install_rspec
        install_footnotes
        config_env
        install_figaro
        git_init
        say 'Dont forget to run config_env'
      end



      def install_capistrano
        insert_into_file 'Gemfile', after: "group :development do\n" do <<-CODE
  gem 'capistrano', '~> 3.6', group: :development
  gem 'capistrano-rails', '~> 1.3', group: :development
  gem 'capistrano-rvm', group: :development
CODE
      end

        run 'bundle install'
        run 'bundle exec cap install'
        gsub_file 'Capfile', '# require "capistrano/rvm"', 'require "capistrano/rvm"'
        gsub_file 'config/deploy.rb', '# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp', 'ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp'
        gsub_file 'config/deploy.rb', '# set :deploy_to, "/var/www/my_app_name"', 'set :deploy_to, "/var/www/#{fetch(:application)}"'
        gsub_file 'config/deploy.rb', '# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"', 'append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"'

        run 'mkdir -p config/deploy/templates/maintenance'

        Dir["#{__dir__}/myrails/templates/capistrano/**/*"].each do |file|
          copy_file file, "#{file.gsub(__dir__+'/myrails/templates/capistrano/', '')}" unless File.directory? file
        end

        insert_into_file 'config/deploy.rb', before: '# Default branch is :master' do <<-CODE
set :deploy_via, :remote_cache
set :ssh_options, {forward_agent: true}
CODE
        end
        insert_into_file 'Capfile', after: "require \"capistrano/rvm\"\n" do <<-CODE
require "capistrano/rails"
CODE
        end
        insert_into_file 'config/deploy.rb', after: "# set :ssh_options, verify_host_key: :secure\n" do <<-CODE
namespace :deploy do
  # after :restart, :clear_cache do
  #   on roles(:app), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
  before :finishing, :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
      invoke 'nginx:restart'
    end
  end

  task :upload_app_yml do
    on roles(:app) do
      info 'Uploading application.yml'
      upload!("\#{Dir.pwd}/config/application.yml", "\#{fetch(:release_path)}/config")
    end
  end

  before :starting, 'maintenance:on'
  before :starting, 'monit:stop'
  before :compile_assets, :upload_app_yml
  before :published, 'nginx:create_nginx_config'
  before :published, 'unicorn:create_unicorn_config'
  before :published,'unicorn:create_unicorn_init'
  after :restart, 'monit:create_monit_conf'
  after :finished, 'monit:start'
  after :finished, 'maintenance:off'
end
CODE
          end

        insert_into_file 'config/deploy/production.rb', before: "# role-based syntax" do <<-CODE
set :fqdn,'domain.com'
CODE
        end

        insert_into_file 'config/deploy/staging.rb', before: "# role-based syntax" do <<-CODE
set :fqdn,'domain.com'
CODE
        end
      end
      
      def install_figaro
        insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem "figaro"
CODE
        end
        
        run 'bundle install'
        run 'bundle exec figaro install'
        copy_file 'rails/config/application.example.yml', 'config/application.example.yml'
      end
      
    end
    # end of no_tasks

    desc 'model', "Generates a rails model with the given name along with its related spec file and namespace prefix for table creation. Use '/' to create a namespaced model"
    option :name, required: true
    def model
      template 'rails/app/models/model.rb', "app/models/#{options[:name].downcase}.rb"
      template 'rails/app/models/namespace_model.rb', "app/models/#{options[:name].split("/").first.singularize.downcase}.rb" if options[:name].include?("/")
      template 'spec/model.rb', "spec/models/#{options[:name].downcase}_spec.rb"
    end

    desc 'controller', "Generates a rails controller with the given name along with related spec file. Use '/' to create a namespaced controller"
    option :name, required: true
    def controller
      template 'rails/app/controllers/controller.rb', "app/controllers/#{options[:name].downcase.pluralize}_controller.rb"
      if options[:name].include?("/")
        parent, child = options[:name].split("/")
        template 'rails/app/controllers/namespace_controller.rb', "app/controllers/#{parent}/#{parent.downcase}_controller.rb"
      end
      template 'spec/controller.rb', "spec/controllers/#{options[:name].downcase.pluralize}_controller_spec.rb"
      run "mkdir -p app/views/#{options[:name].downcase.pluralize}"
    end

    desc 'policy', "Generates a pundit policy with the given name and a related spec file. Use '/' to create a namespaced policy"
    option :name, required: true
    def policy
      template 'rails/app/policies/pundit.rb', "app/policies/#{options[:name].downcase}_policy.rb"
      template 'spec/pundit.rb', "spec/policies/#{options[:name].downcase}_policy_spec.rb"
    end

    desc 'presenter', "Generates a presenter class with the given name and a related spec file. Use '/' to create a namespaced presenter"
    option :name, required: true
    def presenters
      copy_file 'rails/app/presenters/base.rb', 'app/presenters/base_presenter.rb'
      template 'rails/app/presenters/presenter.rb', "app/presenters/#{options[:name].downcase}_presenter.rb"
      copy_file 'rails/app/presenters/presenter_config.rb', 'spec/support/configs/presenter.rb'
      template 'rails/app/presenters/presenter_spec.rb', "spec/presenters/#{options[:name].downcase}_presenter_spec.rb"
    end

    desc 'factory', "Generates a factory_bot factory in the spec/factories directory. Use '/' to create a namespaced factory"
    option :name, required: true
    def factory
      template 'spec/factory.rb', "spec/factories/#{options[:name].downcase}.rb"
    end

    desc 'sendgrid', 'Generate sendgrid initializer and mail interceptor'
    option :email, required: true
    def sendgrid
      copy_file 'rails/app/mailers/sendgrid.rb', 'config/initializers/sendgrid.rb'
      template 'rails/app/mailers/dev_mail_interceptor.rb', 'app/mailers/dev_mail_interceptor.rb'
      ENVIRONMENTS.each do |environment|
        unless environment == 'production'
          inject_into_file "config/environments/#{environment}.rb", after: "Rails.application.configure do\n" do <<-CODE
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
        case environment
        when 'development'
          inject_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false\n" do <<-CODE
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = false
config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
CODE
          end
        when 'test'
          inject_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test\n" do <<-CODE
config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
CODE
          end
        when 'production'
          inject_into_file 'config/environments/production.rb', after: "config.active_record.dump_schema_after_migration = false\n" do <<-CODE
config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
config.assets.compile = true
CODE
          end
        end
      end
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

    desc 'engine_setup', 'Configure rails engine for development with RSpec, Capybara and FactoryBot'
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
  s.add_development_dependency 'factory_bot_rails'
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
      
      Dir["#{__dir__}/myrails/templates/spec/**/*"].each do |file|
        if file.include? '/support/'
          copy_file file, "#{file.gsub(__dir__+'/myrails/templates/', '')}" unless File.directory? file
        end
      end
      
      copy_file 'engines/rakefile', 'Rakefile'
      
      run 'rails g rspec:install'

      gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }", "Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }"

      gsub_file 'spec/rails_helper.rb', "require File.expand_path('../../config/environment', __FILE__)", "require_relative 'dummy/config/environment'"

      inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do <<-CODE
require 'shoulda/matchers'
require 'factory_bot'
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
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
        CODE
      end
    end

    desc 'shared_example', 'Generates an RSpec shared example template in the support directory'
    option :text, required: true
    def shared_example
      template 'spec/shared_example.rb', 'spec/support/shared_examples/shared_examples.rb'
    end

    desc 'request', 'Generates an RSpec request spec'
    option :name, required: true
    def request
      template 'spec/request.rb', "spec/requests/#{options[:name]}_spec.rb"
      copy_file 'spec/request_shared_example.rb', 'spec/support/shared_examples/request_shared_examples.rb'
    end
    
    desc 'feature', 'Generates an RSpec feature spec'
    option :name, required: true
    def feature
      copy_file 'spec/feature.rb', "spec/features/#{options[:name]}_spec.rb"
    end

    desc 'install NAME', 'Install customizations to convfigure application quickly. Type `myrails install` for options'
    def install(name=nil)
      options = {
        application_helper: 'Overwrite default application helper with a custom helper',
        gems: 'Install default gem set',
        layout: 'Generate assets and custom styles using either Boostrap or Material',
        ui: 'Generate UI resource',
        pundit: 'Install and configure Pundit gem',
        rspec: 'Install and configure Rspec gem',
        footnotes: 'Install and configure Footnotes gem',
        base: 'Run through all options listed in this list',
        git: 'Generate git directory and ignore default files',
        heroku: 'Generate needed setup for Heroku deployment',
        devise: 'Generate and configure Devise gem',
        dotenv: 'Generate and configure Dotenv gem (Do not use if figaro is already installed)',
        capistrano: 'Generate capistrano with default deployment',
        figaro: 'Generate and configure Figaro Gem (Do not use if dotenv is already installed)',
        env_config: 'Configure environment files with default hosts etc.'
      }
      unless name
        say 'ERROR: "myrails install" was called with no arguments'
        say 'Usage: "myrails install NAME"'
        say "Available Options:\n"
        options.each{|k,v| say "* #{k}: #{v}"}
        exit
      end

      case name
      when 'application_helper'
        install_application_helper
      when 'gems'
        install_gems
      when 'layout'
        install_layout
      when 'ui'
        install_ui
      when 'pundit'
        install_pundit
        install_rails_helper
      when 'rspec'
        install_rspec
      when 'footnotes'
        install_footnotes
      when 'base'
        base_install
      when 'git'
        git_init
      when 'heroku'
        install_heroku
      when 'devise'
        install_devise
      when 'dotenv'
        install_dotenv
      when 'capistrano'
        install_capistrano
      when 'figaro'
        install_figaro
      when 'env_config'
        config_env
      else
        say "Unknown Action!"
      end
    end

  end
end

Myrails::Myrails.start(ARGV)
