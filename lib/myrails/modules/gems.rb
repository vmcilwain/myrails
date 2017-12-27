module Install
  module Gems
    def self.included(thor)
      thor.class_eval do

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

        def add_development_test_gems
          insert_into_file 'Gemfile', after: "group :development, :test do\n" do <<-CODE
  gem 'faker'
  gem 'yard'
  gem 'letter_opener'
  gem "rails-erd"
CODE
          end
        end

        def add_gems
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
        end

        def add_private_section
          insert_into_file 'app/controllers/application_controller.rb', before: 'end' do <<-CODE
private
  CODE
          end
        end

        def install_gems
          add_test_group
          add_development_test_gems
          add_gems
          run 'bundle install'
          add_private_section
        end
        
      end
    end
  end
end
