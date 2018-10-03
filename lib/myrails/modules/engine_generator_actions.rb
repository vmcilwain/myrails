module Engine
  module Generator
    module Actions
      def self.included(thor)
        thor.class_eval do

          desc 'new_engine', 'Generate a full or mountable engine. default: mountable'
          def new_engine
            type = ask('Type (mountable or full)?: ', default: 'mountable')
            run "rails plugin new #{@name} --dummy-path=spec/dummy --skip-test-unit --#{type}"
          end
        
          desc 'gemspec_setup', 'Generate gemspec info for a rails engine'
          def gemspec_setup
            @email = ask('What email address would you like to use for this rails engine?:')
            @author = ask('Who is the author of this rails engine?')
            
            gsub_file "#{@name}.gemspec", "s.authors     = [\"TODO: Your name\"]", "s.authors     = [\"#{@author}\"]"
            gsub_file "#{@name}.gemspec", "s.email       = [\"TODO: Your email\"]", "s.email       = [\"#{@email}\"]"
            gsub_file "#{@name}.gemspec", 's.homepage    = "TODO"', 's.homepage    = "http://TBD.com"'
            gsub_file "#{@name}.gemspec", "s.summary     = \"TODO: Summary of #{@name.camelize}.\"", "s.summary     = \"Summary of #{@name.camelize}.\""
            gsub_file "#{@name}.gemspec", "s.description = \"TODO: Description of #{@name.camelize}.\"", "s.description = \"Description of #{@name.camelize}.\""

            inject_into_file "#{@name}.gemspec", after: "s.license     = \"MIT\"\n" do <<-CODE
  s.test_files = Dir["spec/**/*"]
CODE
            end
            
            gem_setup
          end

          desc 'gem_setup', 'Generate gem dependencies for a rails engine'
          def gem_setup
            inject_into_file "#{@name}.gemspec", after: "s.add_development_dependency \"sqlite3\"\n" do <<-CODE
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
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'autoprefixer-rails'
  s.add_dependency "haml-rails"
  s.add_dependency "font-awesome-rails"
  s.add_dependency 'record_tag_helper'
CODE
            end

            run 'bundle'
          end

          desc 'rake_setup', 'Generate custom rake file for rails engine'
          def rake_setup
            run 'cp Rakefile Rakefile.bak'
            copy_file 'engines/rakefile', 'Rakefile'
          end

          desc 'rspec_setup', 'Install and configure rspec for a rails engine'
          def rspec_setup
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

            Dir["#{__dir__}/../templates/spec/support/**/*"].each do |file|
              unless File.directory? file
                copy_file file, "spec/support/#{File.basename(file)}"
              end
            end
          end

          desc 'engin_setup', 'Configure a rails engine after its generated'
          def engine_setup
            inject_into_file "lib/#{@name}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-CODE
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
CODE
            end
          end

          desc 'auto_setup', 'Configure rails engine for development with RSpec, Capybara and FactoryBot'
          def auto_setup
            engine_setup unless Dir["lib/#{@name}/engine.rb"].empty?
            gemspec_setup
            rake_setup
            rspec_setup
          end

        end
      end
    end
  end
end
