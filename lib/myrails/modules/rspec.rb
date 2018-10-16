module Install
  module RSpec
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_rspec_gem', 'Add RSpec gem to Gemfile and run bundler'
        def add_rspec_gem
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'rspec-rails', group: :test
CODE
          end

          run 'bundle install'
        end
        
        desc 'generate_rspec', 'Run RSpec generator'
        def generate_rspec
          run 'rails g rspec:install'
        end
        
        desc 'setup_rspec_defaults', 'add default entris to spec/rails_helper.rb'
        def setup_simplecov_capybara
          inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'\n" do <<-CODE
require 'simplecov'
SimpleCov.start

CODE
          end
        end
        
        desc 'enable_support', 'Enable support files'
        def enable_support
          gsub_file 'spec/rails_helper.rb', "# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }", "Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }"
        end
        
        desc 'disable_transctional_fixtures', 'Turn off transactional fixtures option'
        def disable_transctional_fixtures
          gsub_file "spec/rails_helper.rb", "config.use_transactional_fixtures = true", "config.use_transactional_fixtures = false"
        end
        
        
        desc 'include_modules', 'Include useful modules used in feature specs'
        def include_modules
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

        desc 'install_rails_helper', 'Add code to rspec/rails_helper so rspec runs the way I like'
        def setup_rails_helper
          setup_simplecov_capybara
          enable_support
          disable_transctional_fixtures
          include_modules
        end

        desc 'setup_support_files', 'Generate RSpecsupport files'
        def setup_support_files
          Dir["#{__dir__}/../templates/spec/**/*"].each do |file|
            if file.include?('/support/') && !['devise'].include?(File.basename(file, '.rb'))
              copy_file file, "#{file.gsub(__dir__+'/../templates/', '')}" unless File.directory? file
            end
          end
        end
        
        desc 'setup_rspec', 'Generate rspec structure & rspec configuration that I commonly use'
        def setup_rspec
          add_rspec_gem
          generate_rspec
          setup_rails_helper
          setup_support_files
        end
        
      end
    end
  end
end
