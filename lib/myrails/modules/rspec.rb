module Install
  module RSpec
    def self.included(thor)
      thor.class_eval do

        desc 'install_rspec', 'Generate rspec structure & rspec configuration that I commonly use'
        def install_rspec
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'rspec-rails', group: :test
CODE
          end

          run 'bundle install'
          run 'rails g rspec:install'

          install_rails_helper

          Dir["#{__dir__}/../templates/spec/**/*"].each do |file|
            if file.include?('/support/') && !['devise'].include?(File.basename(file, '.rb'))
              copy_file file, "#{file.gsub(__dir__+'/../templates/', '')}" unless File.directory? file
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

      end
    end
  end
end
