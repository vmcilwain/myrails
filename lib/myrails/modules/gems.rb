module Install
  module Gems
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_test_group', 'Add test group gems to Gemfile'
        def add_test_group
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
        end

        desc 'add_development_test_gems', 'Add test and development group gems to Gemfile'
        def add_development_test_gems
          insert_into_file 'Gemfile', after: "group :development, :test do\n" do <<-CODE
  gem 'faker'
  gem 'yard'
  gem 'letter_opener'
  gem 'rails-erd'
  
  # vscode debugger gems: https://github.com/Microsoft/vscode-recipes/tree/master/debugging-Ruby-on-Rails
  gem 'ruby-debug-ide'
  gem 'debase'
CODE
          end
        end

        desc 'add_rails_gems', 'Add commonly used gems to Gemfile'
        def add_rails_gems
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'haml-rails'
gem "ransack"
gem 'will_paginate'
gem "font-awesome-rails"
# gem 'trix'
gem 'trix-rails', require: 'trix' # Official trix gem does not support rails 5.2.1 yet (2018-10-16)
gem 'record_tag_helper'
gem 'jquery-rails'
# active-storage gems
# should also run brew install mupdf-tools ffmpeg to get file previews for non images
gem "mini_magick"
gem 'image_processing'
# gem 'meta_request', group: :development # Uncomment if using rails panel chrome extension
CODE
          end
        end

        desc 'add_private_section', 'Add private section to appliation controller'
        def add_private_section
          insert_into_file 'app/controllers/application_controller.rb', before: 'end' do <<-CODE
  private
 CODE
          end
        end

        desc 'setup_gems', 'Install development, test and prodution gems'
        def setup_gems
          add_test_group
          add_development_test_gems
          add_rails_gems
          run 'bundle install'
          add_private_section
        end

      end
    end
  end
end
