module Rails
  module Engines
    def self.included(thor)
      thor.class_eval do

        desc 'engine(full | mountable)', 'Generate a full or mountable engine. default: mountable'
        option :name, required: true
        def engine(etype='mountable')
          run "rails plugin new #{options[:name]} --dummy-path=spec/dummy --skip-test-unit --#{etype}"
        end

        def add_gemspec_info
          gsub_file "#{options[:name]}.gemspec", 's.homepage    = "TODO"', 's.homepage    = "http://TBD.com"'
          gsub_file "#{options[:name]}.gemspec", "s.summary     = \"TODO: Summary of #{options[:name].camelize}.\"", "s.summary     = \"Summary of #{options[:name].camelize}.\""
          gsub_file "#{options[:name]}.gemspec", "s.description = \"TODO: Description of #{options[:name].camelize}.\"", "s.description = \"Description of #{options[:name].camelize}.\""

          inject_into_file "#{options[:name]}.gemspec", after: "s.license     = \"MIT\"\n" do <<-CODE
      s.test_files = Dir["spec/**/*"]
            CODE
          end
        end

        def add_gems
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
        end

        def copy_rspec_files
          Dir["#{__dir__}/myrails/templates/spec/**/*"].each do |file|
            if file.include? '/support/'
              copy_file file, "#{file.gsub(__dir__+'/myrails/templates/', '')}" unless File.directory? file
            end
          end
        end

        def configure_rake_file
          copy_file 'engines/rakefile', 'Rakefile'
        end

        def configure_rspec
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
        end

        def configure_engine
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

        desc 'engine_setup', 'Configure rails engine for development with RSpec, Capybara and FactoryBot'
        option :name, required: true
        def engine_setup
          add_gemspec_info
          add_gems
          configure_rake_file
          configure_rspec
          copy_rspec_files
          configure_engine
        end

      end
    end
  end
end
